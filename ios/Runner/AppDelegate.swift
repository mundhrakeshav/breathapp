import Flutter
import UIKit
import Intents

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    static var pendingAction: String?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        
        let channel = FlutterMethodChannel(
            name: "shortcuts_channel",
            binaryMessenger: controller.binaryMessenger
        )
        
        channel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "addShortcut":
                self?.createSiriShortcut()
                result(nil)
            case "getLastAction":
                result(AppDelegate.pendingAction)
                AppDelegate.pendingAction = nil
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        handleDeepLink(url)
        return true
    }
    
    override func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        handleUserActivity(userActivity)
        return true
    }
    
    private func handleDeepLink(_ url: URL) {
        if url.scheme == "breathapp" {
            triggerBreathAction()
        }
    }
    
    private func handleUserActivity(_ userActivity: NSUserActivity) {
        if userActivity.activityType == "BreathAction" {
            triggerBreathAction()
        }
    }
    
    private func triggerBreathAction() {
        DispatchQueue.main.async {
            AppDelegate.pendingAction = "breath"
            NotificationCenter.default.post(
                name: Notification.Name("TriggerBreath"),
                object: nil
            )
        }
    }
    
    private func createSiriShortcut() {
        let activity = NSUserActivity(activityType: "BreathAction")
        activity.title = "Start Breathing Exercise"
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = "com.yourapp.breathAction"
        activity.suggestedInvocationPhrase = "Start breathing now"
        activity.becomeCurrent()
        
        let shortcut = INShortcut(userActivity: activity)
        INVoiceShortcutCenter.shared.setShortcutSuggestions([shortcut])
    }
}