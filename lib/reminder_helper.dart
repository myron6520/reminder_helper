import 'package:reminder_helper/reminder.dart';

import 'calendar.dart';
import 'reminder_helper_platform_interface.dart';

class ReminderHelper {
  Future<String?> getPlatformVersion() {
    return ReminderHelperPlatform.instance.getPlatformVersion();
  }

  Future<List<Calendar>> getCalendars() {
    return ReminderHelperPlatform.instance.getCalendars();
  }

  Future<bool> requestPermission() {
    return ReminderHelperPlatform.instance.requestPermission();
  }

  Future<List<Reminder>> getRemindersByCalendarId(String id) {
    return ReminderHelperPlatform.instance.getRemindersByCalendarId(id);
  }
}
