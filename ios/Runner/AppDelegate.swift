import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Set up method channel for widget actions
    let controller = window?.rootViewController as! FlutterViewController
    let widgetChannel = FlutterMethodChannel(
      name: "com.mango.app/widgets",
      binaryMessenger: controller.binaryMessenger
    )
    
    widgetChannel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "openWidgetGallery":
        // iOS doesn't have a public API to open widget gallery directly.
        // Open app settings as the closest alternative.
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(settingsURL, options: [:]) { success in
            result(success)
          }
        } else {
          result(FlutterError(code: "UNAVAILABLE", message: "Cannot open settings", details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
