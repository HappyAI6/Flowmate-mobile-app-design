import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/event.dart';
import '../models/note.dart';
import '../utils/constants.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();
  
  StorageService._();
  
  SharedPreferences? _prefs;
  
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }
  
  // Generic methods
  Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }
  
  String? getString(String key) {
    return prefs.getString(key);
  }
  
  Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }
  
  bool? getBool(String key) {
    return prefs.getBool(key);
  }
  
  Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }
  
  int? getInt(String key) {
    return prefs.getInt(key);
  }
  
  Future<bool> setStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }
  
  List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }
  
  Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }
  
  Future<bool> clear() async {
    return await prefs.clear();
  }
  
  bool containsKey(String key) {
    return prefs.containsKey(key);
  }
  
  // Task-specific methods
  Future<bool> saveTasks(List<Task> tasks) async {
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    final tasksString = jsonEncode(tasksJson);
    return await setString(AppConstants.keyTasks, tasksString);
  }
  
  List<Task> loadTasks() {
    final tasksString = getString(AppConstants.keyTasks);
    if (tasksString == null) return [];
    
    try {
      final tasksJson = jsonDecode(tasksString) as List;
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      print('Error loading tasks: $e');
      return [];
    }
  }
  
  Future<bool> saveTask(Task task) async {
    final tasks = loadTasks();
    final existingIndex = tasks.indexWhere((t) => t.id == task.id);
    
    if (existingIndex >= 0) {
      tasks[existingIndex] = task;
    } else {
      tasks.add(task);
    }
    
    return await saveTasks(tasks);
  }
  
  Future<bool> deleteTask(String taskId) async {
    final tasks = loadTasks();
    tasks.removeWhere((task) => task.id == taskId);
    return await saveTasks(tasks);
  }
  
  // Event-specific methods
  Future<bool> saveEvents(List<Event> events) async {
    final eventsJson = events.map((event) => event.toJson()).toList();
    final eventsString = jsonEncode(eventsJson);
    return await setString(AppConstants.keyEvents, eventsString);
  }
  
  List<Event> loadEvents() {
    final eventsString = getString(AppConstants.keyEvents);
    if (eventsString == null) return [];
    
    try {
      final eventsJson = jsonDecode(eventsString) as List;
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      print('Error loading events: $e');
      return [];
    }
  }
  
  Future<bool> saveEvent(Event event) async {
    final events = loadEvents();
    final existingIndex = events.indexWhere((e) => e.id == event.id);
    
    if (existingIndex >= 0) {
      events[existingIndex] = event;
    } else {
      events.add(event);
    }
    
    return await saveEvents(events);
  }
  
  Future<bool> deleteEvent(String eventId) async {
    final events = loadEvents();
    events.removeWhere((event) => event.id == eventId);
    return await saveEvents(events);
  }
  
  // Note-specific methods
  Future<bool> saveNotes(List<Note> notes) async {
    final notesJson = notes.map((note) => note.toJson()).toList();
    final notesString = jsonEncode(notesJson);
    return await setString(AppConstants.keyNotes, notesString);
  }
  
  List<Note> loadNotes() {
    final notesString = getString(AppConstants.keyNotes);
    if (notesString == null) return [];
    
    try {
      final notesJson = jsonDecode(notesString) as List;
      return notesJson.map((json) => Note.fromJson(json)).toList();
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }
  
  Future<bool> saveNote(Note note) async {
    final notes = loadNotes();
    final existingIndex = notes.indexWhere((n) => n.id == note.id);
    
    if (existingIndex >= 0) {
      notes[existingIndex] = note;
    } else {
      notes.add(note);
    }
    
    return await saveNotes(notes);
  }
  
  Future<bool> deleteNote(String noteId) async {
    final notes = loadNotes();
    notes.removeWhere((note) => note.id == noteId);
    return await saveNotes(notes);
  }
  
  // Focus session methods
  Future<bool> saveFocusSession(Map<String, dynamic> session) async {
    final sessions = loadFocusSessions();
    sessions.add(session);
    final sessionsString = jsonEncode(sessions);
    return await setString(AppConstants.keyFocusSessions, sessionsString);
  }
  
  List<Map<String, dynamic>> loadFocusSessions() {
    final sessionsString = getString(AppConstants.keyFocusSessions);
    if (sessionsString == null) return [];
    
    try {
      final sessionsJson = jsonDecode(sessionsString) as List;
      return sessionsJson.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error loading focus sessions: $e');
      return [];
    }
  }
  
  // App settings methods
  Future<bool> setFirstLaunch(bool isFirstLaunch) async {
    return await setBool(AppConstants.keyFirstLaunch, isFirstLaunch);
  }
  
  bool isFirstLaunch() {
    return getBool(AppConstants.keyFirstLaunch) ?? true;
  }
  
  // Backup and restore methods
  Future<Map<String, dynamic>> exportData() async {
    return {
      'tasks': loadTasks().map((task) => task.toJson()).toList(),
      'events': loadEvents().map((event) => event.toJson()).toList(),
      'notes': loadNotes().map((note) => note.toJson()).toList(),
      'focusSessions': loadFocusSessions(),
      'exportDate': DateTime.now().toIso8601String(),
      'version': AppConstants.appVersion,
    };
  }
  
  Future<bool> importData(Map<String, dynamic> data) async {
    try {
      // Import tasks
      if (data['tasks'] != null) {
        final tasks = (data['tasks'] as List)
            .map((json) => Task.fromJson(json))
            .toList();
        await saveTasks(tasks);
      }
      
      // Import events
      if (data['events'] != null) {
        final events = (data['events'] as List)
            .map((json) => Event.fromJson(json))
            .toList();
        await saveEvents(events);
      }
      
      // Import notes
      if (data['notes'] != null) {
        final notes = (data['notes'] as List)
            .map((json) => Note.fromJson(json))
            .toList();
        await saveNotes(notes);
      }
      
      // Import focus sessions
      if (data['focusSessions'] != null) {
        final sessionsString = jsonEncode(data['focusSessions']);
        await setString(AppConstants.keyFocusSessions, sessionsString);
      }
      
      return true;
    } catch (e) {
      print('Error importing data: $e');
      return false;
    }
  }
}

