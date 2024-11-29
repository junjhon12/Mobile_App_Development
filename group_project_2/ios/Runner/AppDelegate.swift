import Flutter
import UIKit
import GoogleMaps // Import Google Maps SDK

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Provide the API key to Google Maps SDK
    GMSServices.provideAPIKey("AIzaSyD1r64ujhtgOpqg8hbO1w8nfO3rAwvPnHM")
    
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)
    
    // Return the result of the super class' method
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
