import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService.instance;
  
  List<Task> _tasks = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedPriority = 'All';
  String _sortBy = 'dueDate';
  bool _showCompleted = true;
  
  // Getters
  List<Task> get tasks => _filteredTasks;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedPriority => _selectedPriority;
  String get sortBy => _sortBy;
  bool get showCompleted => _showCompleted;
  
  List<Task> get _filteredTasks {
    List<Task> filtered = List.from(_tasks);
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) {
        return task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               task.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               task.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }
    
    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered.where((task) => task.category == _selectedCategory).toList();
    }
    
    // Apply priority filter
    if (_selectedPriority != 'All') {
      filtered = filtered.where((task) => task.priority == _selectedPriority).toList();
    }
    
    // Apply completion filter
    if (!_showCompleted) {
      filtered = filtered.where((task) => !task.isCompleted).toList();
    }
    
    // Apply sorting
    switch (_sortBy) {
      case 'dueDate':
        filtered = _taskService.sortTasksByDueDate(filtered);
        break;
      case 'priority':
        filtered = _taskService.sortTasksByPriority(filtered);
        break;
      case 'title':
        filtered = _taskService.sortTasksByTitle(filtered);
        break;
      case 'createdAt':
        filtered = _taskService.sortTasksByCreatedDate(filtered);
        break;
    }
    
    return filtered;
  }
  
  // Statistics
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((task) => task.isCompleted).length;
  int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;
  int get overdueTasks => _tasks.where((task) => task.isOverdue).length;
  int get todayTasks => _tasks.where((task) => task.isDueToday).length;
  
  double get completionRate {
    if (_tasks.isEmpty) return 0.0;
    return completedTasks / totalTasks;
  }
  
  List<String> get categories {
    final categories = _tasks
        .where((task) => task.category != null)
        .map((task) => task.category!)
        .toSet()
        .toList();
    categories.sort();
    return ['All', ...categories];
  }
  
  List<String> get priorities {
    return ['All', 'Low', 'Medium', 'High', 'Urgent'];
  }
  
  // Methods
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _tasks = await _taskService.getAllTasks();
      
      // Add sample data if no tasks exist
      if (_tasks.isEmpty) {
        await _addSampleTasks();
        _tasks = await _taskService.getAllTasks();
      }
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> _addSampleTasks() async {
    final sampleTasks = [
      Task(
        title: 'Welcome to FlowMate!',
        description: 'This is your first task. Tap to mark it as complete!',
        priority: 'Medium',
        category: 'Getting Started',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        tags: ['welcome', 'tutorial'],
      ),
      Task(
        title: 'Plan weekly goals',
        description: 'Set up your goals for this week and break them down into actionable tasks.',
        priority: 'High',
        category: 'Planning',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        tags: ['planning', 'goals'],
      ),
      Task(
        title: 'Review project documentation',
        description: 'Go through the project docs and update any outdated information.',
        priority: 'Low',
        category: 'Work',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        tags: ['documentation', 'review'],
      ),
      Task(
        title: 'Call dentist for appointment',
        description: 'Schedule routine dental checkup for next month.',
        priority: 'Medium',
        category: 'Personal',
        dueDate: DateTime.now().add(const Duration(hours: 2)),
        tags: ['health', 'appointment'],
      ),
      Task(
        title: 'Grocery shopping',
        description: 'Buy ingredients for this week\'s meal prep.',
        priority: 'Medium',
        category: 'Personal',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        tags: ['shopping', 'food'],
      ),
    ];
    
    for (final task in sampleTasks) {
      await _taskService.createTask(task);
    }
  }
  
  Future<bool> addTask(Task task) async {
    try {
      final success = await _taskService.createTask(task);
      if (success) {
        _tasks.add(task);
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint('Error adding task: $e');
      return false;
    }
  }
  
  Future<bool> updateTask(Task task) async {
    try {
      final success = await _taskService.updateTask(task);
      if (success) {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index >= 0) {
          _tasks[index] = task;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      debugPrint('Error updating task: $e');
      return false;
    }
  }
  
  Future<bool> deleteTask(String taskId) async {
    try {
      final success = await _taskService.deleteTask(taskId);
      if (success) {
        _tasks.removeWhere((task) => task.id == taskId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint('Error deleting task: $e');
      return false;
    }
  }
  
  Future<bool> toggleTaskCompletion(String taskId) async {
    try {
      final success = await _taskService.toggleTaskCompletion(taskId);
      if (success) {
        final index = _tasks.indexWhere((task) => task.id == taskId);
        if (index >= 0) {
          _tasks[index] = _tasks[index].copyWith(
            isCompleted: !_tasks[index].isCompleted,
          );
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      debugPrint('Error toggling task completion: $e');
      return false;
    }
  }
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
  
  void setSelectedPriority(String priority) {
    _selectedPriority = priority;
    notifyListeners();
  }
  
  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }
  
  void setShowCompleted(bool show) {
    _showCompleted = show;
    notifyListeners();
  }
  
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedPriority = 'All';
    _sortBy = 'dueDate';
    _showCompleted = true;
    notifyListeners();
  }
  
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
  
  List<Task> getTasksByPriority(String priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }
  
  List<Task> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }
  
  List<Task> getTodayTasks() {
    return _tasks.where((task) => task.isDueToday).toList();
  }
  
  List<Task> getTomorrowTasks() {
    return _tasks.where((task) => task.isDueTomorrow).toList();
  }
  
  List<Task> getOverdueTasks() {
    return _tasks.where((task) => task.isOverdue).toList();
  }
  
  List<Task> getCompletedTasks() {
    return _tasks.where((task) => task.isCompleted).toList();
  }
  
  List<Task> getPendingTasks() {
    return _tasks.where((task) => !task.isCompleted).toList();
  }
  
  Future<bool> markAllAsCompleted(List<String> taskIds) async {
    try {
      final success = await _taskService.markAllTasksAsCompleted(taskIds);
      if (success) {
        for (final taskId in taskIds) {
          final index = _tasks.indexWhere((task) => task.id == taskId);
          if (index >= 0) {
            _tasks[index] = _tasks[index].copyWith(isCompleted: true);
          }
        }
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint('Error marking tasks as completed: $e');
      return false;
    }
  }
  
  Future<bool> deleteMultipleTasks(List<String> taskIds) async {
    try {
      final success = await _taskService.deleteMultipleTasks(taskIds);
      if (success) {
        _tasks.removeWhere((task) => taskIds.contains(task.id));
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint('Error deleting multiple tasks: $e');
      return false;
    }
  }
}
