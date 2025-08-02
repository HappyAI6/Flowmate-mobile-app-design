import '../models/event.dart';
import 'storage_service.dart';

class CalendarService {
  static CalendarService? _instance;
  static CalendarService get instance => _instance ??= CalendarService._();
  
  CalendarService._();
  
  final StorageService _storage = StorageService.instance;
  
  // CRUD Operations
  Future<List<Event>> getAllEvents() async {
    return _storage.loadEvents();
  }
  
  Future<Event?> getEventById(String id) async {
    final events = await getAllEvents();
    try {
      return events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> createEvent(Event event) async {
    return await _storage.saveEvent(event);
  }
  
  Future<bool> updateEvent(Event event) async {
    return await _storage.saveEvent(event);
  }
  
  Future<bool> deleteEvent(String eventId) async {
    return await _storage.deleteEvent(eventId);
  }
  
  // Date-based filtering
  Future<List<Event>> getEventsForDate(DateTime date) async {
    final events = await getAllEvents();
    return events.where((event) {
      return event.startTime.year == date.year &&
             event.startTime.month == date.month &&
             event.startTime.day == date.day;
    }).toList();
  }
  
  Future<List<Event>> getEventsForDateRange(DateTime startDate, DateTime endDate) async {
    final events = await getAllEvents();
    return events.where((event) {
      return event.startTime.isAfter(startDate.subtract(const Duration(days: 1))) &&
             event.startTime.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }
  
  Future<List<Event>> getTodayEvents() async {
    final today = DateTime.now();
    return await getEventsForDate(today);
  }
  
  Future<List<Event>> getTomorrowEvents() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return await getEventsForDate(tomorrow);
  }
  
  Future<List<Event>> getThisWeekEvents() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return await getEventsForDateRange(startOfWeek, endOfWeek);
  }
  
  Future<List<Event>> getThisMonthEvents() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    return await getEventsForDateRange(startOfMonth, endOfMonth);
  }
  
  Future<List<Event>> getUpcomingEvents({int days = 7}) async {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: days));
    return await getEventsForDateRange(now, futureDate);
  }
  
  Future<List<Event>> getPastEvents({int days = 30}) async {
    final now = DateTime.now();
    final pastDate = now.subtract(Duration(days: days));
    final events = await getEventsForDateRange(pastDate, now);
    return events.where((event) => event.isPast).toList();
  }
  
  Future<List<Event>> getOngoingEvents() async {
    final events = await getAllEvents();
    return events.where((event) => event.isOngoing).toList();
  }
  
  // Search and filtering
  Future<List<Event>> searchEvents(String query) async {
    final events = await getAllEvents();
    final lowercaseQuery = query.toLowerCase();
    
    return events.where((event) {
      return event.title.toLowerCase().contains(lowercaseQuery) ||
             event.description.toLowerCase().contains(lowercaseQuery) ||
             (event.location?.toLowerCase().contains(lowercaseQuery) ?? false) ||
             event.attendees.any((attendee) => attendee.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }
  
  Future<List<Event>> getEventsByLocation(String location) async {
    final events = await getAllEvents();
    return events.where((event) => 
        event.location?.toLowerCase() == location.toLowerCase()).toList();
  }
  
  Future<List<Event>> getAllDayEvents() async {
    final events = await getAllEvents();
    return events.where((event) => event.isAllDay).toList();
  }
  
  Future<List<Event>> getRecurringEvents() async {
    final events = await getAllEvents();
    return events.where((event) => event.recurrence != null).toList();
  }
  
  // Sorting methods
  List<Event> sortEventsByStartTime(List<Event> events, {bool ascending = true}) {
    events.sort((a, b) {
      final comparison = a.startTime.compareTo(b.startTime);
      return ascending ? comparison : -comparison;
    });
    return events;
  }
  
  List<Event> sortEventsByDuration(List<Event> events, {bool ascending = false}) {
    events.sort((a, b) {
      final comparison = a.duration.compareTo(b.duration);
      return ascending ? comparison : -comparison;
    });
    return events;
  }
  
  List<Event> sortEventsByTitle(List<Event> events, {bool ascending = true}) {
    events.sort((a, b) {
      final comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
      return ascending ? comparison : -comparison;
    });
    return events;
  }
  
  // Conflict detection
  Future<List<Event>> getConflictingEvents(Event newEvent) async {
    final events = await getAllEvents();
    return events.where((event) => 
        event.id != newEvent.id && event.conflictsWith(newEvent)).toList();
  }
  
  Future<bool> hasConflicts(Event event) async {
    final conflicts = await getConflictingEvents(event);
    return conflicts.isNotEmpty;
  }
  
  // Statistics and Analytics
  Future<Map<String, int>> getEventStatistics() async {
    final events = await getAllEvents();
    final today = DateTime.now();
    
    final todayEvents = events.where((event) => event.isToday).length;
    final upcomingEvents = events.where((event) => event.isUpcoming).length;
    final pastEvents = events.where((event) => event.isPast).length;
    final ongoingEvents = events.where((event) => event.isOngoing).length;
    final allDayEvents = events.where((event) => event.isAllDay).length;
    
    return {
      'total': events.length,
      'today': todayEvents,
      'upcoming': upcomingEvents,
      'past': pastEvents,
      'ongoing': ongoingEvents,
      'allDay': allDayEvents,
    };
  }
  
  Future<Map<String, int>> getEventsByTypeCount() async {
    final events = await getAllEvents();
    final Map<String, int> typeCount = {};
    
    for (final event in events) {
      final type = event.eventType;
      typeCount[type] = (typeCount[type] ?? 0) + 1;
    }
    
    return typeCount;
  }
  
  Future<Duration> getTotalScheduledTime({DateTime? startDate, DateTime? endDate}) async {
    List<Event> events;
    
    if (startDate != null && endDate != null) {
      events = await getEventsForDateRange(startDate, endDate);
    } else {
      events = await getAllEvents();
    }
    
    Duration total = Duration.zero;
    for (final event in events) {
      total += event.duration;
    }
    
    return total;
  }
  
  Future<List<String>> getAllLocations() async {
    final events = await getAllEvents();
    final locations = events
        .where((event) => event.location != null && event.location!.isNotEmpty)
        .map((event) => event.location!)
        .toSet()
        .toList();
    locations.sort();
    return locations;
  }
  
  Future<List<String>> getAllAttendees() async {
    final events = await getAllEvents();
    final attendees = <String>{};
    
    for (final event in events) {
      attendees.addAll(event.attendees);
    }
    
    final attendeeList = attendees.toList();
    attendeeList.sort();
    return attendeeList;
  }
  
  // Calendar view helpers
  Future<Map<DateTime, List<Event>>> getEventsGroupedByDate(
      DateTime startDate, DateTime endDate) async {
    final events = await getEventsForDateRange(startDate, endDate);
    final Map<DateTime, List<Event>> groupedEvents = {};
    
    for (final event in events) {
      final eventDate = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      
      if (groupedEvents[eventDate] == null) {
        groupedEvents[eventDate] = [];
      }
      groupedEvents[eventDate]!.add(event);
    }
    
    // Sort events within each day
    for (final date in groupedEvents.keys) {
      groupedEvents[date] = sortEventsByStartTime(groupedEvents[date]!);
    }
    
    return groupedEvents;
  }
  
  Future<List<Event>> getEventsForWeek(DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return await getEventsForDateRange(weekStart, weekEnd);
  }
  
  // Bulk operations
  Future<bool> deleteMultipleEvents(List<String> eventIds) async {
    try {
      for (final eventId in eventIds) {
        await deleteEvent(eventId);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> updateEventColor(String eventId, String newColor) async {
    final event = await getEventById(eventId);
    if (event == null) return false;
    
    final updatedEvent = event.copyWith(color: newColor);
    return await updateEvent(updatedEvent);
  }
  
  Future<bool> addAttendeeToEvent(String eventId, String attendee) async {
    final event = await getEventById(eventId);
    if (event == null) return false;
    
    final newAttendees = List<String>.from(event.attendees);
    if (!newAttendees.contains(attendee)) {
      newAttendees.add(attendee);
      final updatedEvent = event.copyWith(attendees: newAttendees);
      return await updateEvent(updatedEvent);
    }
    return true;
  }
  
  Future<bool> removeAttendeeFromEvent(String eventId, String attendee) async {
    final event = await getEventById(eventId);
    if (event == null) return false;
    
    final newAttendees = List<String>.from(event.attendees);
    newAttendees.remove(attendee);
    final updatedEvent = event.copyWith(attendees: newAttendees);
    return await updateEvent(updatedEvent);
  }
}

