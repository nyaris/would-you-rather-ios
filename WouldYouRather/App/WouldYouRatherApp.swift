import SwiftUI

@main
struct WouldYouRatherApp: App {
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            AppShellView()
                .environmentObject(router)
                .tint(AppColor.ink)
        }
    }
}
