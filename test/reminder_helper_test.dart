import 'package:flutter_test/flutter_test.dart';
import 'package:reminder_helper/reminder_helper.dart';
import 'package:reminder_helper/reminder_helper_platform_interface.dart';
import 'package:reminder_helper/reminder_helper_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockReminderHelperPlatform
    with MockPlatformInterfaceMixin
    implements ReminderHelperPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ReminderHelperPlatform initialPlatform = ReminderHelperPlatform.instance;

  test('$MethodChannelReminderHelper is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelReminderHelper>());
  });

  test('getPlatformVersion', () async {
    ReminderHelper reminderHelperPlugin = ReminderHelper();
    MockReminderHelperPlatform fakePlatform = MockReminderHelperPlatform();
    ReminderHelperPlatform.instance = fakePlatform;

    expect(await reminderHelperPlugin.getPlatformVersion(), '42');
  });
}
