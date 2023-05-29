import UIKit
import Flutter
import FirebaseMessaging
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return true
    
    //commenting original line for push notifications
    //return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
