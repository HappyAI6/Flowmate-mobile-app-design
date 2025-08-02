import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onDelete;
  final bool showCheckbox;
  final bool isSelected;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.onDelete,
    this.showCheckbox = true,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priorityColor = AppHelpers.getPriorityColor(task.priority);
    
    return Card(
      elevation: isSelected ? 4 : 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            border: isSelected
                ? Border.all(color: theme.colorScheme.primary, width: 2)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Row(
              children: [
                // Checkbox
                if (showCheckbox)
                  GestureDetector(
                    onTap: onToggleComplete,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: task.isCompleted
                              ? AppConstants.success
                              : theme.colorScheme.onSurface.withOpacity(0.3),
                          width: 2,
                        ),
                        color: task.isCompleted
                            ? AppConstants.success
                            : Colors.transparent,
                      ),
                      child: task.isCompleted
                          ? const Icon(
                              Icons.check,
                              color: AppConstants.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                
                if (showCheckbox) const SizedBox(width: AppConstants.spacingM),
                
                // Priority Indicator
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: priorityColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                const SizedBox(width: AppConstants.spacingM),
                
                // Task Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        task.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? theme.colorScheme.onSurface.withOpacity(0.6)
                              : theme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      // Description
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.spacingXS),
                        Text(
                          task.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      
                      const SizedBox(height: AppConstants.spacingS),
                      
                      // Task Info Row
                      Row(
                        children: [
                          // Priority Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingS,
                              vertical: AppConstants.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppConstants.radiusS),
                            ),
                            child: Text(
                              task.priority,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: priorityColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          
                          // Category Badge
                          if (task.category != null) ...[
                            const SizedBox(width: AppConstants.spacingS),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.spacingS,
                                vertical: AppConstants.spacingXS,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppConstants.radiusS),
                              ),
                              child: Text(
                                task.category!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          
                          const Spacer(),
                          
                          // Due Date
                          if (task.dueDate != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 14,
                                  color: task.isOverdue
                                      ? AppConstants.error
                                      : theme.colorScheme.onSurface.withOpacity(0.5),
                                ),
                                const SizedBox(width: AppConstants.spacingXS),
                                Text(
                                  AppHelpers.getRelativeDateString(task.dueDate!),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: task.isOverdue
                                        ? AppConstants.error
                                        : theme.colorScheme.onSurface.withOpacity(0.7),
                                    fontWeight: task.isOverdue
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      
                      // Tags
                      if (task.tags.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.spacingS),
                        Wrap(
                          spacing: AppConstants.spacingXS,
                          runSpacing: AppConstants.spacingXS,
                          children: task.tags.take(3).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.spacingS,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppConstants.radiusS),
                              ),
                              child: Text(
                                '#$tag',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.secondary,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Actions
                if (onDelete != null) ...[
                  const SizedBox(width: AppConstants.spacingS),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: AppConstants.error,
                    onPressed: onDelete,
                    iconSize: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

