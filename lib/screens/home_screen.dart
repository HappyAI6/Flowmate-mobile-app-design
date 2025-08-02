import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/home_widgets/overview_card.dart';
import '../widgets/home_widgets/quick_stats.dart';
import '../widgets/common/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good ${_getGreeting()}!',
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
            Text(
              AppHelpers.formatDate(DateTime.now()),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          const SizedBox(width: AppConstants.spacingS),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => taskProvider.loadTasks(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Stats
                  QuickStats(taskProvider: taskProvider),
                  
                  const SizedBox(height: AppConstants.spacingL),
                  
                  // Overview Cards
                  Row(
                    children: [
                      Expanded(
                        child: OverviewCard(
                          title: 'Today\'s Tasks',
                          value: taskProvider.todayTasks.toString(),
                          icon: Icons.today,
                          color: AppConstants.primaryBlue,
                          onTap: () => _navigateToTasks(context, 'today'),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingM),
                      Expanded(
                        child: OverviewCard(
                          title: 'Overdue',
                          value: taskProvider.overdueTasks.toString(),
                          icon: Icons.warning,
                          color: AppConstants.error,
                          onTap: () => _navigateToTasks(context, 'overdue'),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppConstants.spacingM),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OverviewCard(
                          title: 'Completed',
                          value: taskProvider.completedTasks.toString(),
                          icon: Icons.check_circle,
                          color: AppConstants.success,
                          onTap: () => _navigateToTasks(context, 'completed'),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingM),
                      Expanded(
                        child: OverviewCard(
                          title: 'Total Tasks',
                          value: taskProvider.totalTasks.toString(),
                          icon: Icons.list,
                          color: AppConstants.primaryPurple,
                          onTap: () => _navigateToTasks(context, 'all'),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppConstants.spacingL),
                  
                  // Recent Tasks Section
                  _buildSectionHeader(
                    context,
                    'Recent Tasks',
                    Icons.task_alt,
                    onViewAll: () => _navigateToTasks(context, 'all'),
                  ),
                  
                  const SizedBox(height: AppConstants.spacingM),
                  
                  _buildRecentTasks(context, taskProvider),
                  
                  const SizedBox(height: AppConstants.spacingL),
                  
                  // Today's Schedule Section
                  _buildSectionHeader(
                    context,
                    'Today\'s Schedule',
                    Icons.schedule,
                    onViewAll: () => _navigateToCalendar(context),
                  ),
                  
                  const SizedBox(height: AppConstants.spacingM),
                  
                  _buildTodaySchedule(context),
                  
                  const SizedBox(height: AppConstants.spacingL),
                  
                  // Quick Actions
                  _buildQuickActions(context),
                  
                  const SizedBox(height: AppConstants.spacingXL),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onViewAll,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppConstants.spacingS),
        Text(
          title,
          style: theme.textTheme.displaySmall?.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        ),
        const Spacer(),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: const Text('View All'),
          ),
      ],
    );
  }

  Widget _buildRecentTasks(BuildContext context, TaskProvider taskProvider) {
    final recentTasks = taskProvider.tasks.take(3).toList();
    
    if (recentTasks.isEmpty) {
      return _buildEmptyState(
        context,
        'No tasks yet',
        'Create your first task to get started!',
        Icons.task_alt,
      );
    }

    return Column(
      children: recentTasks.map((task) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
          child: TaskCard(
            task: task,
            onTap: () => _editTask(context, task),
            onToggleComplete: () => taskProvider.toggleTaskCompletion(task.id),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTodaySchedule(BuildContext context) {
    // This would integrate with calendar events
    // For now, showing a placeholder
    return _buildEmptyState(
      context,
      'No events today',
      'Your schedule is clear for today!',
      Icons.event_available,
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.displaySmall?.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: AppConstants.spacingM),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                'New Task',
                Icons.add_task,
                AppConstants.primaryBlue,
                () => _createNewTask(context),
              ),
            ),
            const SizedBox(width: AppConstants.spacingM),
            Expanded(
              child: _buildQuickActionCard(
                context,
                'New Note',
                Icons.note_add,
                AppConstants.primaryPurple,
                () => _createNewNote(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingM),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                'New Event',
                Icons.event,
                AppConstants.softGreen,
                () => _createNewEvent(context),
              ),
            ),
            const SizedBox(width: AppConstants.spacingM),
            Expanded(
              child: _buildQuickActionCard(
                context,
                'Focus Timer',
                Icons.timer,
                AppConstants.softPink,
                () => _startFocusTimer(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: AppConstants.spacingS),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingL),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: theme.colorScheme.onBackground.withOpacity(0.3),
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToTasks(BuildContext context, String filter) {
    // Navigate to tasks screen with filter
    // This would be implemented with proper navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigate to $filter tasks')),
    );
  }

  void _navigateToCalendar(BuildContext context) {
    // Navigate to calendar screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to calendar')),
    );
  }

  void _editTask(BuildContext context, task) {
    // Navigate to task edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit task: ${task.title}')),
    );
  }

  void _createNewTask(BuildContext context) {
    // Navigate to create task screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new task')),
    );
  }

  void _createNewNote(BuildContext context) {
    // Navigate to create note screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new note')),
    );
  }

  void _createNewEvent(BuildContext context) {
    // Navigate to create event screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new event')),
    );
  }

  void _startFocusTimer(BuildContext context) {
    // Navigate to focus timer screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Start focus timer')),
    );
  }
}

