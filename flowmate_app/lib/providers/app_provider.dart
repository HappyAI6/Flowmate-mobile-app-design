import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../models/task.dart';
import '../models/note.dart';
import '../models/event.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  // Authentication state
  User? _currentUser;
  bool _isLoggedIn = false;

  // App state
  bool _isDarkMode = false;
  int _currentTabIndex = 0;

  // Data collections
  List<Task> _tasks = [];
  List<Note> _notes = [];
  List<Event> _events = [];

  // Timer state
  bool _timerRunning = false;
  int _timerTime = 25 * 60; // 25 minutes in seconds
  int _completedSessions = 0;
  String _timerMode = 'work'; // 'work' or 'break'
  Timer? _timer;

  final Uuid _uuid = const Uuid();

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isDarkMode => _isDarkMode;
  int get currentTabIndex => _currentTabIndex;
  
  List<Task> get tasks => _tasks;
  List<Note> get notes => _notes;
  List<Event> get events => _events;
  
  bool get timerRunning => _timerRunning;
  int get timerTime => _timerTime;
  int get completedSessions => _completedSessions;
  String get timerMode => _timerMode;

  // Computed properties
  List<Task> get todaysTasks {
    return _tasks.where((task) {
      if (task.dueDate == null) return true;
      return task.isDueToday;
    }).toList();
  }

  List<Event> get todaysEvents {
    return _events.where((event) => event.isToday).toList();
  }

  List<Task> get completedTasks => _tasks.where((task) => task.completed).toList();
  List<Task> get pendingTasks => _tasks.where((task) => !task.completed).toList();
  List<Task> get overdueTasks => _tasks.where((task) => task.isOverdue).toList();

  double get taskProgress {
    if (todaysTasks.isEmpty) return 0.0;
    final completed = todaysTasks.where((task) => task.completed).length;
    return completed / todaysTasks.length;
  }

  // Initialize app
  Future<void> initializeApp() async {
    await _loadSettings();
    await _loadUserData();
    await _loadData();
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    _isDarkMode = StorageService.getDarkMode();
    _completedSessions = StorageService.getCompletedSessions();
    _timerMode = StorageService.getTimerMode();
    _timerTime = StorageService.getTimerTime();
  }

  Future<void> _loadUserData() async {
    _currentUser = StorageService.getCurrentUser();
    _isLoggedIn = _currentUser != null;
  }

  Future<void> _loadData() async {
    _tasks = StorageService.getAllTasks();
    _notes = StorageService.getAllNotes();
    _events = StorageService.getAllEvents();
  }

  // Authentication methods
  Future<void> login(String email, String password, [String? name]) async {
    final user = User(
      name: name ?? email.split('@')[0],
      email: email,
      createdAt: DateTime.now(),
    );
    
    await StorageService.saveUser(user);
    _currentUser = user;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await StorageService.clearUser();
    _currentUser = null;
    _isLoggedIn = false;
    _stopTimer();
    notifyListeners();
  }

  // App settings
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.saveDarkMode(_isDarkMode);
    notifyListeners();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // Task methods
  Future<void> addTask({
    required String title,
    String? description,
    required TaskPriority priority,
    DateTime? dueDate,
  }) async {
    final now = DateTime.now();
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      completed: false,
      priority: priority,
      dueDate: dueDate,
      createdAt: now,
      updatedAt: now,
    );

    await StorageService.saveTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(String taskId, {
    String? title,
    String? description,
    bool? completed,
    TaskPriority? priority,
    DateTime? dueDate,
  }) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final oldTask = _tasks[taskIndex];
    final updatedTask = oldTask.copyWith(
      title: title,
      description: description,
      completed: completed,
      priority: priority,
      dueDate: dueDate,
      updatedAt: DateTime.now(),
    );

    await StorageService.saveTask(updatedTask);
    _tasks[taskIndex] = updatedTask;
    notifyListeners();
  }

  Future<void> toggleTask(String taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    await updateTask(taskId, completed: !task.completed);
  }

  Future<void> deleteTask(String taskId) async {
    await StorageService.deleteTask(taskId);
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  // Note methods
  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    final now = DateTime.now();
    final note = Note(
      id: _uuid.v4(),
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );

    await StorageService.saveNote(note);
    _notes.insert(0, note); // Add to beginning for recency
    notifyListeners();
  }

  Future<void> updateNote(String noteId, {
    String? title,
    String? content,
  }) async {
    final noteIndex = _notes.indexWhere((note) => note.id == noteId);
    if (noteIndex == -1) return;

    final oldNote = _notes[noteIndex];
    final updatedNote = oldNote.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
    );

    await StorageService.saveNote(updatedNote);
    _notes[noteIndex] = updatedNote;
    
    // Move to front for recency
    _notes.removeAt(noteIndex);
    _notes.insert(0, updatedNote);
    notifyListeners();
  }

  Future<void> deleteNote(String noteId) async {
    await StorageService.deleteNote(noteId);
    _notes.removeWhere((note) => note.id == noteId);
    notifyListeners();
  }

  // Event methods
  Future<void> addEvent({
    required String title,
    String? description,
    required DateTime date,
    required String time,
  }) async {
    final now = DateTime.now();
    final event = Event(
      id: _uuid.v4(),
      title: title,
      description: description,
      date: date,
      time: time,
      createdAt: now,
      updatedAt: now,
    );

    await StorageService.saveEvent(event);
    _events.add(event);
    _events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }

  Future<void> updateEvent(String eventId, {
    String? title,
    String? description,
    DateTime? date,
    String? time,
  }) async {
    final eventIndex = _events.indexWhere((event) => event.id == eventId);
    if (eventIndex == -1) return;

    final oldEvent = _events[eventIndex];
    final updatedEvent = oldEvent.copyWith(
      title: title,
      description: description,
      date: date,
      time: time,
      updatedAt: DateTime.now(),
    );

    await StorageService.saveEvent(updatedEvent);
    _events[eventIndex] = updatedEvent;
    _events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }

  Future<void> deleteEvent(String eventId) async {
    await StorageService.deleteEvent(eventId);
    _events.removeWhere((event) => event.id == eventId);
    notifyListeners();
  }

  List<Event> getEventsForDate(DateTime date) {
    return _events.where((event) {
      return event.date.year == date.year &&
             event.date.month == date.month &&
             event.date.day == date.day;
    }).toList();
  }

  // Timer methods
  void startTimer() {
    if (_timer != null) return;
    
    _timerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerTime > 0) {
        _timerTime--;
        notifyListeners();
      } else {
        _onTimerComplete();
      }
    });
    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    _timerRunning = false;
    notifyListeners();
  }

  void stopTimer() {
    _stopTimer();
    _resetTimer();
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _timerRunning = false;
  }

  void _resetTimer() {
    final isWork = _timerMode == 'work';
    _timerTime = isWork ? 25 * 60 : 5 * 60;
    StorageService.saveTimerTime(_timerTime);
    notifyListeners();
  }

  void _onTimerComplete() {
    _stopTimer();
    
    if (_timerMode == 'work') {
      _completedSessions++;
      StorageService.saveCompletedSessions(_completedSessions);
      _timerMode = 'break';
      _timerTime = 5 * 60; // 5 minute break
    } else {
      _timerMode = 'work';
      _timerTime = 25 * 60; // 25 minute work session
    }
    
    StorageService.saveTimerMode(_timerMode);
    StorageService.saveTimerTime(_timerTime);
    notifyListeners();
  }

  void setWorkSession() {
    _stopTimer();
    _timerMode = 'work';
    _timerTime = 25 * 60;
    StorageService.saveTimerMode(_timerMode);
    StorageService.saveTimerTime(_timerTime);
    notifyListeners();
  }

  void setBreakSession() {
    _stopTimer();
    _timerMode = 'break';
    _timerTime = 5 * 60;
    StorageService.saveTimerMode(_timerMode);
    StorageService.saveTimerTime(_timerTime);
    notifyListeners();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}