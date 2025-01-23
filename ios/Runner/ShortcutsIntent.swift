import AppIntents

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