import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/common/task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSelectionMode = false;
  final Set<String> _selectedTasks = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: _isSelectionMode
            ? Text('${_selectedTasks.length} selected')
            : const Text('Tasks'),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.check_circle),
              onPressed: _markSelectedAsCompleted,
              tooltip: 'Mark as completed',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedTasks,
              tooltip: 'Delete selected',
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _exitSelectionMode,
              tooltip: 'Cancel selection',
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _showSearchDialog,
              tooltip: 'Search tasks',
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterDialog,
              tooltip: 'Filter tasks',
            ),
            PopupMenuButton<String>(
              onSelected: _handleMenuAction,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'select_multiple',
                  child: Row(
                    children: [
                      Icon(Icons.checklist),
                      SizedBox(width: 8),
                      Text('Select Multiple'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'sort',
                  child: Row(
                    children: [
                      Icon(Icons.sort),
                      SizedBox(width: 8),
                      Text('Sort'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_filters',
                  child: Row(
                    children: [
                      Icon(Icons.clear_all),
                      SizedBox(width: 8),
                      Text('Clear Filters'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              // Filter Chips
              _buildFilterChips(context, taskProvider),
              
              // Task List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => taskProvider.loadTasks(),
                  child: taskProvider.tasks.isEmpty
                      ? _buildEmptyState(context, taskProvider)
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppConstants.spacingM),
                          itemCount: taskProvider.tasks.length,
                          itemBuilder: (context, index) {
                            final task = taskProvider.tasks[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppConstants.spacingS,
                              ),
                              child: TaskCard(
                                task: task,
                                isSelected: _selectedTasks.contains(task.id),
                                onTap: () => _isSelectionMode
                                    ? _toggleTaskSelection(task.id)
                                    : _editTask(context, task),
                                onToggleComplete: () =>
                                    taskProvider.toggleTaskCompletion(task.id),
                                onDelete: _isSelectionMode
                                    ? null
                                    : () => _deleteTask(context, taskProvider, task.id),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _isSelectionMode
          ? null
          : FloatingActionButton(
              onPressed: () => _createNewTask(context),
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildFilterChips(BuildContext context, TaskProvider taskProvider) {
    final theme = Theme.of(context);
    final hasActiveFilters = taskProvider.searchQuery.isNotEmpty ||
        taskProvider.selectedCategory != 'All' ||
        taskProvider.selectedPriority != 'All' ||
        !taskProvider.showCompleted;

    if (!hasActiveFilters) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: AppConstants.spacingS,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (taskProvider.searchQuery.isNotEmpty)
              _buildFilterChip(
                context,
                'Search: "${taskProvider.searchQuery}"',
                () => taskProvider.setSearchQuery(''),
              ),
            if (taskProvider.selectedCategory != 'All')
              _buildFilterChip(
                context,
                'Category: ${taskProvider.selectedCategory}',
                () => taskProvider.setSelectedCategory('All'),
              ),
            if (taskProvider.selectedPriority != 'All')
              _buildFilterChip(
                context,
                'Priority: ${taskProvider.selectedPriority}',
                () => taskProvider.setSelectedPriority('All'),
              ),
            if (!taskProvider.showCompleted)
              _buildFilterChip(
                context,
                'Hide Completed',
                () => taskProvider.setShowCompleted(true),
              ),
            const SizedBox(width: AppConstants.spacingS),
            TextButton.icon(
              onPressed: () => taskProvider.clearFilters(),
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text('Clear All'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingS,
                  vertical: AppConstants.spacingXS,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    VoidCallback onRemove,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: AppConstants.spacingS),
      child: Chip(
        label: Text(label),
        onDeleted: onRemove,
        deleteIcon: const Icon(Icons.close, size: 16),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: AppConstants.fontSizeXS,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, TaskProvider taskProvider) {
    final theme = Theme.of(context);
    final hasFilters = taskProvider.searchQuery.isNotEmpty ||
        taskProvider.selectedCategory != 'All' ||
        taskProvider.selectedPriority != 'All' ||
        !taskProvider.showCompleted;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.search_off : Icons.task_alt,
              size: 64,
              color: theme.colorScheme.onBackground.withOpacity(0.3),
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              hasFilters ? 'No tasks match your filters' : 'No tasks yet',
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              hasFilters
                  ? 'Try adjusting your search or filters'
                  : 'Create your first task to get started!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingL),
            if (hasFilters)
              ElevatedButton(
                onPressed: () => taskProvider.clearFilters(),
                child: const Text('Clear Filters'),
              )
            else
              ElevatedButton.icon(
                onPressed: () => _createNewTask(context),
                icon: const Icon(Icons.add),
                label: const Text('Create Task'),
              ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'select_multiple':
        _enterSelectionMode();
        break;
      case 'sort':
        _showSortDialog();
        break;
      case 'clear_filters':
        context.read<TaskProvider>().clearFilters();
        break;
    }
  }

  void _enterSelectionMode() {
    setState(() {
      _isSelectionMode = true;
      _selectedTasks.clear();
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedTasks.clear();
    });
  }

  void _toggleTaskSelection(String taskId) {
    setState(() {
      if (_selectedTasks.contains(taskId)) {
        _selectedTasks.remove(taskId);
      } else {
        _selectedTasks.add(taskId);
      }
    });
  }

  void _markSelectedAsCompleted() async {
    final taskProvider = context.read<TaskProvider>();
    final success = await taskProvider.markAllAsCompleted(_selectedTasks.toList());
    
    if (success) {
      AppHelpers.showSnackBar(
        context,
        '${_selectedTasks.length} tasks marked as completed',
        backgroundColor: AppConstants.success,
      );
      _exitSelectionMode();
    } else {
      AppHelpers.showSnackBar(
        context,
        'Failed to update tasks',
        backgroundColor: AppConstants.error,
      );
    }
  }

  void _deleteSelectedTasks() async {
    final confirmed = await AppHelpers.showConfirmDialog(
      context,
      title: 'Delete Tasks',
      content: 'Are you sure you want to delete ${_selectedTasks.length} tasks?',
      confirmText: 'Delete',
    );

    if (confirmed == true) {
      final taskProvider = context.read<TaskProvider>();
      final success = await taskProvider.deleteMultipleTasks(_selectedTasks.toList());
      
      if (success) {
        AppHelpers.showSnackBar(
          context,
          '${_selectedTasks.length} tasks deleted',
          backgroundColor: AppConstants.success,
        );
        _exitSelectionMode();
      } else {
        AppHelpers.showSnackBar(
          context,
          'Failed to delete tasks',
          backgroundColor: AppConstants.error,
        );
      }
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Tasks'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Enter search query...',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
          onSubmitted: (value) {
            context.read<TaskProvider>().setSearchQuery(value);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskProvider>().setSearchQuery(_searchController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    final taskProvider = context.read<TaskProvider>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Category'),
            DropdownButton<String>(
              value: taskProvider.selectedCategory,
              isExpanded: true,
              items: taskProvider.categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  taskProvider.setSelectedCategory(value);
                }
              },
            ),
            const SizedBox(height: AppConstants.spacingM),
            const Text('Priority'),
            DropdownButton<String>(
              value: taskProvider.selectedPriority,
              isExpanded: true,
              items: taskProvider.priorities.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  taskProvider.setSelectedPriority(value);
                }
              },
            ),
            const SizedBox(height: AppConstants.spacingM),
            CheckboxListTile(
              title: const Text('Show Completed'),
              value: taskProvider.showCompleted,
              onChanged: (value) {
                taskProvider.setShowCompleted(value ?? true);
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    final taskProvider = context.read<TaskProvider>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Due Date'),
              value: 'dueDate',
              groupValue: taskProvider.sortBy,
              onChanged: (value) {
                if (value != null) {
                  taskProvider.setSortBy(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Priority'),
              value: 'priority',
              groupValue: taskProvider.sortBy,
              onChanged: (value) {
                if (value != null) {
                  taskProvider.setSortBy(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Title'),
              value: 'title',
              groupValue: taskProvider.sortBy,
              onChanged: (value) {
                if (value != null) {
                  taskProvider.setSortBy(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Created Date'),
              value: 'createdAt',
              groupValue: taskProvider.sortBy,
              onChanged: (value) {
                if (value != null) {
                  taskProvider.setSortBy(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createNewTask(BuildContext context) {
    // Navigate to create task screen
    AppHelpers.showSnackBar(context, 'Create new task feature coming soon!');
  }

  void _editTask(BuildContext context, Task task) {
    // Navigate to edit task screen
    AppHelpers.showSnackBar(context, 'Edit task: ${task.title}');
  }

  void _deleteTask(BuildContext context, TaskProvider taskProvider, String taskId) async {
    final confirmed = await AppHelpers.showConfirmDialog(
      context,
      title: 'Delete Task',
      content: 'Are you sure you want to delete this task?',
      confirmText: 'Delete',
    );

    if (confirmed == true) {
      final success = await taskProvider.deleteTask(taskId);
      if (success) {
        AppHelpers.showSnackBar(
          context,
          'Task deleted',
          backgroundColor: AppConstants.success,
        );
      } else {
        AppHelpers.showSnackBar(
          context,
          'Failed to delete task',
          backgroundColor: AppConstants.error,
        );
      }
    }
  }
}

