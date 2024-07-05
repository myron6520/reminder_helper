import 'package:flutter/cupertino.dart';

///Per RFC 5545, priorities of 1-4 are considered "high," a priority of 5 is "medium," and priorities of 6-9 are "low."
enum ReminderPriority {
  none,
  low,
  medium,
  high,
}

extension ReminderPriorityEx on int {
  ReminderPriority get reminderPriority {
    switch (this) {
      case 1:
      case 2:
      case 3:
      case 4:
        return ReminderPriority.high;
      case 5:
        return ReminderPriority.medium;
      case 6:
      case 7:
      case 8:
      case 9:
        return ReminderPriority.low;
    }
    return ReminderPriority.none;
  }
}

class Reminder {
  late String id;
  late String title;
  late bool isCompleted;
  DateTime? completionDate;
  DateTime? startDateComponents;
  DateTime? dueDateComponents;
  DateTime? creationDate;
  late ReminderPriority priority;
  DateTime? lastModifiedDate;
  late bool hasAlarms;
  late List<ReminderAlarm> alarms;
  late bool hasNotes;
  late String notes;
  late bool hasAttendees;
  late bool hasRecurrenceRules;
  late List<RecurrenceRule> recurrenceRules;
  Reminder.fromMap(Map info) {
    id = "${info['id'] ?? ''}";
    title = "${info['title'] ?? ''}";
    isCompleted = bool.tryParse("${info['isCompleted'] ?? ''}") ?? false;
    if (info["completionDate"] != null) {
      double time = double.tryParse("${info['completionDate'] ?? ''}") ?? 0;
      completionDate =
          DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt());
    }
    if (info["startDateComponents"] != null) {
      double time =
          double.tryParse("${info['startDateComponents'] ?? ''}") ?? 0;
      startDateComponents =
          DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt());
    }
    if (info["dueDateComponents"] != null) {
      double time = double.tryParse("${info['dueDateComponents'] ?? ''}") ?? 0;
      dueDateComponents =
          DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt());
    }
    if (info["creationDate"] != null) {
      double time = double.tryParse("${info['creationDate'] ?? ''}") ?? 0;
      creationDate = DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt());
    }
    priority =
        (int.tryParse("${info['priority'] ?? ''}") ?? 0).reminderPriority;
    if (info["lastModifiedDate"] != null) {
      double time = double.tryParse("${info['lastModifiedDate'] ?? ''}") ?? 0;
      lastModifiedDate =
          DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt());
    }
    hasAlarms = bool.tryParse("${info['hasAlarms'] ?? ''}") ?? false;
    if (hasAlarms) {
      debugPrint("alarms:${info['alarms']}");
      debugPrint("info:${info}");
      alarms = (info["alarms"] ?? [])
          .map<ReminderAlarm>((e) => ReminderAlarm.fromMap(e))
          .toList();
    }
    hasNotes = bool.tryParse("${info['hasNotes'] ?? ''}") ?? false;
    notes = "${info['notes'] ?? ''}";
    hasAttendees = bool.tryParse("${info['hasAttendees'] ?? ''}") ?? false;
    hasRecurrenceRules =
        bool.tryParse("${info['hasRecurrenceRules'] ?? ''}") ?? false;
    if (hasRecurrenceRules) {
      recurrenceRules = (info["recurrenceRules"] ?? [])
          .map<RecurrenceRule>((e) => RecurrenceRule.fromMap(e))
          .toList();
    }
  }
}

enum RecurrenceFrequency {
  daily,
  weekly,
  monthly,
  yearly,
}

extension RecurrenceFrequencyExOnInt on int {
  RecurrenceFrequency? get recurrenceFrequency {
    switch (this) {
      case 0:
        return RecurrenceFrequency.daily;
      case 1:
        return RecurrenceFrequency.weekly;
      case 2:
        return RecurrenceFrequency.monthly;
      case 3:
        return RecurrenceFrequency.yearly;
    }
    return null;
  }
}

class RecurrenceRule {
  late double interval;
  RecurrenceFrequency? frequency;
  RecurrenceEnd? recurrenceEnd;
  RecurrenceRule.fromMap(Map info) {
    interval = double.tryParse("${info['interval'] ?? ''}") ?? 0;
    frequency =
        (int.tryParse("${info['frequency'] ?? ''}") ?? -1).recurrenceFrequency;
    if (info["recurrenceEnd"] != null) {
      recurrenceEnd = RecurrenceEnd.fromMap(info["recurrenceEnd"]);
    }
  }
}

class RecurrenceEnd {
  DateTime? endDate;
  late int occurrenceCount;
  RecurrenceEnd.fromMap(Map info) {
    occurrenceCount = int.tryParse("${info['occurrenceCount'] ?? ''}") ?? 0;
    if (info["endDate"] != null) {
      double time = double.tryParse("${info['endDate'] ?? ''}") ?? 0;
      endDate = DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt());
    }
  }
}

class ReminderAlarm {
  late double relativeOffset;
  DateTime? absoluteDate;
  ReminderAlarm.fromMap(Map info) {
    relativeOffset = double.tryParse("${info['relativeOffset'] ?? ''}") ?? 0;
    if (info["absoluteDate"] != null) {
      double time = double.tryParse("${info['absoluteDate'] ?? ''}") ?? 0;
      absoluteDate = DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt());
    }
  }
}
