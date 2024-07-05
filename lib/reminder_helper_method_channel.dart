import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:reminder_helper/reminder.dart';

import 'calendar.dart';
import 'reminder_helper_platform_interface.dart';

/// An implementation of [ReminderHelperPlatform] that uses method channels.
class MethodChannelReminderHelper extends ReminderHelperPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('reminder_helper');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> requestPermission() async {
    return await methodChannel.invokeMethod<bool>('requestPermission') ?? false;
  }

  @override
  Future<List<Calendar>> getCalendars() async {
    String calendars =
        await methodChannel.invokeMethod<String>('getCalendars') ?? "";
    try {
      if (calendars.isNotEmpty) {
        List list = json.decode(calendars);
        return list.map((e) => Calendar.fromMap(e)).toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  @override
  Future<List<Reminder>> getRemindersByCalendarId(String id) async {
    String reminders = await methodChannel.invokeMethod<String>(
            'getRemindersByCalendarId', id) ??
        "";
    try {
      if (reminders.isNotEmpty) {
        List list = json.decode(reminders);
        return list.map((e) => Reminder.fromMap(e)).toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }
}
