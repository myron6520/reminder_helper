import Flutter
import UIKit

public class ReminderHelperPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "reminder_helper", binaryMessenger: registrar.messenger())
    let instance = ReminderHelperPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    lazy var helper:ReminderHelper = ReminderHelper()

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "requestPermission":
        result(helper.requestPermission())
    case "getCalendars":
        result(helper.getCalendars() ?? "");
    case "getRemindersByCalendarId":
        helper.getReminders(call.arguments as? String) {
            result($0 ?? "");
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
