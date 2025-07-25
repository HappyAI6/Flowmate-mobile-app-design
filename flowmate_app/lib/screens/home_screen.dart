import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../utils/app_theme.dart';
import 'auth/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final user = appProvider.currentUser;
        final todaysTasks = appProvider.todaysTasks;
        final todaysEvents = appProvider.todaysEvents;
        final completedTasksCount = todaysTasks.where((task) => task.completed).length;
        final taskProgress = todaysTasks.isNotEmpty ? completedTasksCount / todaysTasks.length : 0.0;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_getGreeting()}, ${user?.name ?? 'User'}!',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Ready to be productive?',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    switch (value) {
                                      case 'theme':
                                        await appProvider.toggleDarkMode();
                                        break;
                                      case 'logout':
                                        await appProvider.logout();
                                        if (context.mounted) {
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) => const WelcomeScreen(),
                                            ),
                                            (route) => false,
                                          );
                                        }
                                        break;
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'theme',
                                      child: Row(
                                        children: [
                                          Icon(
                                            appProvider.isDarkMode
                                                ? Icons.light_mode
                                                : Icons.dark_mode,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            appProvider.isDarkMode
                                                ? 'Light Mode'
                                                : 'Dark Mode',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'logout',
                                      child: Row(
                                        children: [
                                          Icon(Icons.logout),
                                          SizedBox(width: 8),
                                          Text('Sign Out'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Main Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                        children: [
                          _buildStatCard(
                            context,
                            title: 'Tasks Today',
                            value: '${todaysTasks.length}',
                            icon: Icons.check_circle_outline,
                            color: AppTheme.primaryPurple,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF3E8FF), Color(0xFFE9D5FF)],
                            ),
                          ),
                          _buildStatCard(
                            context,
                            title: 'Events Today',
                            value: '${todaysEvents.length}',
                            icon: Icons.event,
                            color: AppTheme.primaryBlue,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFDBEAFE), Color(0xFFBFDBFE)],
                            ),
                          ),
                          _buildStatCard(
                            context,
                            title: 'Notes',
                            value: '${appProvider.notes.length}',
                            icon: Icons.note_alt_outlined,
                            color: Colors.indigo,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE0E7FF), Color(0xFFC7D2FE)],
                            ),
                          ),
                          _buildStatCard(
                            context,
                            title: 'Focus Sessions',
                            value: '${appProvider.completedSessions}',
                            icon: Icons.timer,
                            color: Colors.pink,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFCE7F3), Color(0xFFFBBF24)],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Today's Progress
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Today\'s Progress',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildProgressItem(
                                context,
                                title: 'Tasks Completed',
                                current: completedTasksCount,
                                total: todaysTasks.length,
                                progress: taskProgress,
                              ),
                              const SizedBox(height: 12),
                              _buildProgressItem(
                                context,
                                title: 'Focus Sessions',
                                current: appProvider.completedSessions,
                                total: 8,
                                progress: (appProvider.completedSessions / 8).clamp(0.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Today's Events
                      if (todaysEvents.isNotEmpty) ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Today\'s Events',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                for (final event in todaysEvents.take(3))
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppTheme.primaryBlue,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                event.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                event.time,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                      ] else ...[
                        const SizedBox(height: 80),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Gradient gradient,
  }) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(
    BuildContext context, {
    required String title,
    required int current,
    required int total,
    required double progress,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '$current/$total',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}