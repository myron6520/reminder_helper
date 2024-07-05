import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:reminder_helper/calendar.dart';
import 'package:reminder_helper/reminder.dart';

import 'reminder_helper_method_channel.dart';

abstract class ReminderHelperPlatform extends PlatformInterface {
  /// Constructs a ReminderHelperPlatform.
  ReminderHelperPlatform() : super(token: _token);

  static final Object _token = Object();

  static ReminderHelperPlatform _instance = MethodChannelReminderHelper();

  /// The default instance of [ReminderHelperPlatform] to use.
  ///
  /// Defaults to [MethodChannelReminderHelper].
  static ReminderHelperPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ReminderHelperPlatform] when
  /// they register themselves.
  static set instance(ReminderHelperPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> requestPermission() {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  Future<List<Calendar>> getCalendars() {
    throw UnimplementedError('getCalendars() has not been implemented.');
  }

  Future<List<Reminder>> getRemindersByCalendarId(String id) {
    throw UnimplementedError(
        'getRemindersByCalendarId() has not been implemented.');
  }
}
