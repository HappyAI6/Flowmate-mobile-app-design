import '../models/task.dart';
import '../utils/constants.dart';
import 'storage_service.dart';

class TaskService {
  static TaskService? _instance;
  static TaskService get instance => _instance ??= TaskService._();
  
  TaskService._();
  
  final StorageService _storage = StorageService.instance;
  
  // CRUD Operations
  Future<List<Task>> getAllTasks() async {
    return _storage.loadTasks();
  }
  
  Future<Task?> getTaskById(String id) async {
    final tasks = await getAllTasks();
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> createTask(Task task) async {
    return await _storage.saveTask(task);
  }
  
  Future<bool> updateTask(Task task) async {
    return await _storage.saveTask(task);
  }
  
  Future<bool> deleteTask(String taskId) async {
    return await _storage.deleteTask(taskId);
  }
  
  Future<bool> toggleTaskCompletion(String taskId) async {
    final task = await getTaskById(taskId);
    if (task == null) return false;
    
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    return await updateTask(updatedTask);
  }
  
  // Filtering and Sorting
  Future<List<Task>> getTasksByPriority(String priority) async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.priority == priority).toList();
  }
  
  Future<List<Task>> getTasksByCategory(String category) async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.category == category).toList();
  }
  
  Future<List<Task>> getCompletedTasks() async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.isCompleted).toList();
  }
  
  Future<List<Task>> getPendingTasks() async {
    final tasks = await getAllTasks();
    return tasks.where((task) => !task.isCompleted).toList();
  }
  
  Future<List<Task>> getOverdueTasks() async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.isOverdue).toList();
  }
  
  Future<List<Task>> getTodayTasks() async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.isDueToday).toList();
  }
  
  Future<List<Task>> getTomorrowTasks() async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.isDueTomorrow).toList();
  }
  
  Future<List<Task>> getThisWeekTasks() async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.isDueThisWeek).toList();
  }
  
  Future<List<Task>> searchTasks(String query) async {
    final tasks = await getAllTasks();
    final lowercaseQuery = query.toLowerCase();
    
    return tasks.where((task) {
      return task.title.toLowerCase().contains(lowercaseQuery) ||
             task.description.toLowerCase().contains(lowercaseQuery) ||
             task.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }
  
  Future<List<Task>> getTasksWithTag(String tag) async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.tags.contains(tag)).toList();
  }
  
  // Sorting methods
  List<Task> sortTasksByPriority(List<Task> tasks, {bool ascending = false}) {
    tasks.sort((a, b) {
      final comparison = a.priorityIndex.compareTo(b.priorityIndex);
      return ascending ? comparison : -comparison;
    });
    return tasks;
  }
  
  List<Task> sortTasksByDueDate(List<Task> tasks, {bool ascending = true}) {
    tasks.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      
      final comparison = a.dueDate!.compareTo(b.dueDate!);
      return ascending ? comparison : -comparison;
    });
    return tasks;
  }
  
  List<Task> sortTasksByCreatedDate(List<Task> tasks, {bool ascending = false}) {
    tasks.sort((a, b) {
      final comparison = a.createdAt.compareTo(b.createdAt);
      return ascending ? comparison : -comparison;
    });
    return tasks;
  }
  
  List<Task> sortTasksByTitle(List<Task> tasks, {bool ascending = true}) {
    tasks.sort((a, b) {
      final comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
      return ascending ? comparison : -comparison;
    });
    return tasks;
  }
  
  // Statistics and Analytics
  Future<Map<String, int>> getTaskStatistics() async {
    final tasks = await getAllTasks();
    final completed = tasks.where((task) => task.isCompleted).length;
    final pending = tasks.where((task) => !task.isCompleted).length;
    final overdue = tasks.where((task) => task.isOverdue).length;
    final dueToday = tasks.where((task) => task.isDueToday).length;
    
    return {
      'total': tasks.length,
      'completed': completed,
      'pending': pending,
      'overdue': overdue,
      'dueToday': dueToday,
    };
  }
  
  Future<Map<String, int>> getTasksByPriorityCount() async {
    final tasks = await getAllTasks();
    final Map<String, int> priorityCount = {};
    
    for (final priority in AppConstants.taskPriorities) {
      priorityCount[priority] = tasks.where((task) => task.priority == priority).length;
    }
    
    return priorityCount;
  }
  
  Future<Map<String, int>> getTasksByCategoryCount() async {
    final tasks = await getAllTasks();
    final Map<String, int> categoryCount = {};
    
    for (final task in tasks) {
      final category = task.category ?? 'Uncategorized';
      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }
    
    return categoryCount;
  }
  
  Future<double> getCompletionRate() async {
    final tasks = await getAllTasks();
    if (tasks.isEmpty) return 0.0;
    
    final completed = tasks.where((task) => task.isCompleted).length;
    return completed / tasks.length;
  }
  
  Future<List<String>> getAllCategories() async {
    final tasks = await getAllTasks();
    final categories = tasks
        .where((task) => task.category != null)
        .map((task) => task.category!)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }
  
  Future<List<String>> getAllTags() async {
    final tasks = await getAllTasks();
    final tags = <String>{};
    
    for (final task in tasks) {
      tags.addAll(task.tags);
    }
    
    final tagList = tags.toList();
    tagList.sort();
    return tagList;
  }
  
  // Bulk operations
  Future<bool> markAllTasksAsCompleted(List<String> taskIds) async {
    try {
      for (final taskId in taskIds) {
        final task = await getTaskById(taskId);
        if (task != null && !task.isCompleted) {
          await updateTask(task.copyWith(isCompleted: true));
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> deleteMultipleTasks(List<String> taskIds) async {
    try {
      for (final taskId in taskIds) {
        await deleteTask(taskId);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> updateTaskPriority(String taskId, String newPriority) async {
    final task = await getTaskById(taskId);
    if (task == null) return false;
    
    final updatedTask = task.copyWith(priority: newPriority);
    return await updateTask(updatedTask);
  }
  
  Future<bool> updateTaskCategory(String taskId, String? newCategory) async {
    final task = await getTaskById(taskId);
    if (task == null) return false;
    
    final updatedTask = task.copyWith(category: newCategory);
    return await updateTask(updatedTask);
  }
  
  Future<bool> addTagToTask(String taskId, String tag) async {
    final task = await getTaskById(taskId);
    if (task == null) return false;
    
    final newTags = List<String>.from(task.tags);
    if (!newTags.contains(tag)) {
      newTags.add(tag);
      final updatedTask = task.copyWith(tags: newTags);
      return await updateTask(updatedTask);
    }
    return true;
  }
  
  Future<bool> removeTagFromTask(String taskId, String tag) async {
    final task = await getTaskById(taskId);
    if (task == null) return false;
    
    final newTags = List<String>.from(task.tags);
    newTags.remove(tag);
    final updatedTask = task.copyWith(tags: newTags);
    return await updateTask(updatedTask);
  }
}

