import 'package:flutter/material.dart';
import '../utils/constants.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search notes
            },
          ),
          IconButton(
            icon: const Icon(Icons.view_module),
            onPressed: () {
              // Toggle view
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
              Icon(
                Icons.note,
                size: 64,
                color: theme.colorScheme.secondary.withOpacity(0.5),
              ),
              const SizedBox(height: AppConstants.spacingM),
              Text(
                'Smart Notes',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: AppConstants.spacingS),
              Text(
                'Card-based notes with rich text editing and search coming soon!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingL),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notes feature coming soon!')),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Create Note'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quick note creation coming soon!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

