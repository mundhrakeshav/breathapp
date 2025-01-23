import Flutter
import UIKit
import AppIntents

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window.rootViewController as! FlutterViewController

        // Set up a channel to listen for shortcut actions
        let channel = FlutterMethodChannel(
            name: "shortcuts_channel",
            binaryMessenger: controller.binaryMessenger
        )

        // Listen for notifications from the intent
        NotificationCenter.default.addObserver(
            forName: .init("ShortcutActionReceived"),
            object: nil,
            queue: .main
        ) { notification in
            if let action = notification.userInfo?["action"] as? String {
                channel.invokeMethod("triggerAction", arguments: action)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

@available(iOS 16.0, *)
struct SearchActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Search in My App"
    static var description = IntentDescription("Triggers a search action in the app.")

    func perform() async throws -> some IntentResult {
        // Notify Flutter to trigger the action
        NotificationCenter.default.post(name: .init("ShortcutActionReceived"), object: nil, userInfo: ["action": "search"])
        return .result()
    }
}

@available(iOS 16.0, *)
struct MyShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: SearchActionIntent(),
            phrases: ["Search in \(.applicationName)"],
            shortTitle: "Search",
            systemImageName: "magnifyingglass"
        )
    }
}