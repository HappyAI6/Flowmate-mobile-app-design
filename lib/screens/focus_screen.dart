import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  bool _isRunning = false;
  int _minutes = AppConstants.defaultWorkDuration;
  int _seconds = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Focus Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Timer settings
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Session history
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Timer Circle
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 8,
                  ),
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingS),
                      Text(
                        _isRunning ? 'Focus Time' : 'Ready to Focus',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.spacingXL),
              
              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Reset Button
                  ElevatedButton(
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingL,
                        vertical: AppConstants.spacingM,
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                  
                  // Start/Stop Button
                  ElevatedButton(
                    onPressed: _toggleTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning 
                          ? AppConstants.error 
                          : theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingXL,
                        vertical: AppConstants.spacingM,
                      ),
                    ),
                    child: Text(_isRunning ? 'Stop' : 'Start'),
                  ),
                  
                  // Skip Button
                  ElevatedButton(
                    onPressed: _skipSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.softYellow,
                      foregroundColor: AppConstants.charcoal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingL,
                        vertical: AppConstants.spacingM,
                      ),
                    ),
                    child: const Text('Skip'),
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.spacingXL),
              
              // Session Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  child: Column(
                    children: [
                      Text(
                        'Pomodoro Technique',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingS),
                      Text(
                        '25 minutes of focused work followed by a 5-minute break',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppConstants.spacingM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(context, 'Sessions Today', '0'),
                          _buildStatItem(context, 'Total Time', '0h 0m'),
                          _buildStatItem(context, 'Streak', '0 days'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.displaySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.spacingXS),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isRunning ? 'Timer started!' : 'Timer paused!'),
        backgroundColor: _isRunning ? AppConstants.success : AppConstants.warning,
      ),
    );
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _minutes = AppConstants.defaultWorkDuration;
      _seconds = 0;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Timer reset!'),
        backgroundColor: AppConstants.info,
      ),
    );
  }

  void _skipSession() {
    setState(() {
      _isRunning = false;
      _minutes = AppConstants.defaultShortBreak;
      _seconds = 0;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session skipped! Break time!'),
        backgroundColor: AppConstants.softGreen,
      ),
    );
  }
}

