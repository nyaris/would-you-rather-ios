import SwiftUI

@main
struct WouldYouRatherApp: App {
    @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            AppShellView()
                .environment(router)
                .tint(AppColor.ink)
        }
    }
}
