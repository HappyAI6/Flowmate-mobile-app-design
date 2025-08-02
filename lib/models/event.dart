import 'package:uuid/uuid.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String color;
  final bool isAllDay;
  final String? recurrence;
  final List<String> attendees;
  final DateTime createdAt;

  Event({
    String? id,
    required this.title,
    this.description = '',
    required this.startTime,
    required this.endTime,
    this.location,
    this.color = '#6B73FF',
    this.isAllDay = false,
    this.recurrence,
    this.attendees = const [],
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Event copyWith({
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? color,
    bool? isAllDay,
    String? recurrence,
    List<String>? attendees,
  }) {
    return Event(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      color: color ?? this.color,
      isAllDay: isAllDay ?? this.isAllDay,
      recurrence: recurrence ?? this.recurrence,
      attendees: attendees ?? this.attendees,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'color': color,
      'isAllDay': isAllDay,
      'recurrence': recurrence,
      'attendees': attendees,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'],
      color: json['color'] ?? '#6B73FF',
      isAllDay: json['isAllDay'] ?? false,
      recurrence: json['recurrence'],
      attendees: List<String>.from(json['attendees'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Event(id: $id, title: $title, startTime: $startTime, endTime: $endTime)';
  }

  // Helper methods
  Duration get duration {
    return endTime.difference(startTime);
  }

  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
           startTime.month == now.month &&
           startTime.day == now.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return startTime.year == tomorrow.year &&
           startTime.month == tomorrow.month &&
           startTime.day == tomorrow.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return startTime.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
           startTime.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  bool get isPast {
    return endTime.isBefore(DateTime.now());
  }

  bool get isOngoing {
    final now = DateTime.now();
    return startTime.isBefore(now) && endTime.isAfter(now);
  }

  bool get isUpcoming {
    return startTime.isAfter(DateTime.now());
  }

  bool conflictsWith(Event other) {
    return (startTime.isBefore(other.endTime) && endTime.isAfter(other.startTime));
  }

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get eventType {
    if (isAllDay) return 'All Day';
    if (duration.inHours >= 8) return 'Full Day';
    if (duration.inHours >= 4) return 'Half Day';
    if (duration.inHours >= 1) return 'Meeting';
    return 'Quick';
  }
}

