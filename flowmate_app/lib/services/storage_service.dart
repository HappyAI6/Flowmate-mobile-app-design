import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/task.dart';
import '../models/note.dart';
import '../models/event.dart';

class StorageService {
  static const String userBoxName = 'user_box';
  static const String tasksBoxName = 'tasks_box';
  static const String notesBoxName = 'notes_box';
  static const String eventsBoxName = 'events_box';
  static const String settingsBoxName = 'settings_box';

  static late Box<User> userBox;
  static late Box<Task> tasksBox;
  static late Box<Note> notesBox;
  static late Box<Event> eventsBox;
  static late Box settingsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskPriorityAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(EventAdapter());

    // Open boxes
    userBox = await Hive.openBox<User>(userBoxName);
    tasksBox = await Hive.openBox<Task>(tasksBoxName);
    notesBox = await Hive.openBox<Note>(notesBoxName);
    eventsBox = await Hive.openBox<Event>(eventsBoxName);
    settingsBox = await Hive.openBox(settingsBoxName);
  }

  // User operations
  static Future<void> saveUser(User user) async {
    await userBox.put('current_user', user);
  }

  static User? getCurrentUser() {
    return userBox.get('current_user');
  }

  static Future<void> clearUser() async {
    await userBox.delete('current_user');
  }

  // Task operations
  static Future<void> saveTask(Task task) async {
    await tasksBox.put(task.id, task);
  }

  static Future<void> deleteTask(String taskId) async {
    await tasksBox.delete(taskId);
  }

  static List<Task> getAllTasks() {
    return tasksBox.values.toList();
  }

  static Task? getTask(String taskId) {
    return tasksBox.get(taskId);
  }

  static Future<void> clearAllTasks() async {
    await tasksBox.clear();
  }

  // Note operations
  static Future<void> saveNote(Note note) async {
    await notesBox.put(note.id, note);
  }

  static Future<void> deleteNote(String noteId) async {
    await notesBox.delete(noteId);
  }

  static List<Note> getAllNotes() {
    return notesBox.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  static Note? getNote(String noteId) {
    return notesBox.get(noteId);
  }

  static Future<void> clearAllNotes() async {
    await notesBox.clear();
  }

  // Event operations
  static Future<void> saveEvent(Event event) async {
    await eventsBox.put(event.id, event);
  }

  static Future<void> deleteEvent(String eventId) async {
    await eventsBox.delete(eventId);
  }

  static List<Event> getAllEvents() {
    return eventsBox.values.toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  static Event? getEvent(String eventId) {
    return eventsBox.get(eventId);
  }

  static Future<void> clearAllEvents() async {
    await eventsBox.clear();
  }

  // Settings operations
  static Future<void> saveDarkMode(bool isDark) async {
    await settingsBox.put('dark_mode', isDark);
  }

  static bool getDarkMode() {
    return settingsBox.get('dark_mode', defaultValue: false);
  }

  static Future<void> saveCompletedSessions(int sessions) async {
    await settingsBox.put('completed_sessions', sessions);
  }

  static int getCompletedSessions() {
    return settingsBox.get('completed_sessions', defaultValue: 0);
  }

  static Future<void> saveTimerMode(String mode) async {
    await settingsBox.put('timer_mode', mode);
  }

  static String getTimerMode() {
    return settingsBox.get('timer_mode', defaultValue: 'work');
  }

  static Future<void> saveTimerTime(int time) async {
    await settingsBox.put('timer_time', time);
  }

  static int getTimerTime() {
    return settingsBox.get('timer_time', defaultValue: 25 * 60);
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await userBox.clear();
    await tasksBox.clear();
    await notesBox.clear();
    await eventsBox.clear();
    await settingsBox.clear();
  }

  // Close all boxes
  static Future<void> close() async {
    await userBox.close();
    await tasksBox.close();
    await notesBox.close();
    await eventsBox.close();
    await settingsBox.close();
  }

  // Helper methods for filtering
  static List<Task> getTodaysTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return getAllTasks().where((task) {
      if (task.dueDate == null) return true;
      final taskDate = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
      return taskDate.isAtSameMomentAs(today);
    }).toList();
  }

  static List<Event> getTodaysEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return getAllEvents().where((event) {
      final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
      return eventDate.isAtSameMomentAs(today);
    }).toList();
  }

  static List<Event> getEventsForDate(DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    
    return getAllEvents().where((event) {
      final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
      return eventDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  static List<Task> getTasksByPriority(TaskPriority priority) {
    return getAllTasks().where((task) => task.priority == priority).toList();
  }

  static List<Task> getCompletedTasks() {
    return getAllTasks().where((task) => task.completed).toList();
  }

  static List<Task> getPendingTasks() {
    return getAllTasks().where((task) => !task.completed).toList();
  }

  static List<Task> getOverdueTasks() {
    return getAllTasks().where((task) => task.isOverdue).toList();
  }
}