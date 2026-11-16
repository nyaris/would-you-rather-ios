import SwiftUI

struct AppShellView: View {
    var body: some View {
        TabView {
            HomePlaceholderView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            NavigationStack {
                PlaceholderView(
                    title: "Categories",
                    message: "Choose a category to start a focused game session."
                )
            }
            .tabItem {
                Label("Categories", systemImage: "square.grid.2x2.fill")
            }

            NavigationStack {
                PlaceholderView(
                    title: "Statistics",
                    message: "Your progress and streaks will appear here."
                )
            }
            .tabItem {
                Label("Statistics", systemImage: "chart.bar.fill")
            }

            NavigationStack {
                PlaceholderView(
                    title: "Settings",
                    message: "Game preferences will be available here."
                )
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
        .accessibilityIdentifier("main-tab-view")
    }
}

private struct HomePlaceholderView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [AppColor.red, AppColor.blue],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: DesignTokens.Spacing.large) {
                    Spacer()

                    VStack(spacing: DesignTokens.Spacing.small) {
                        Text("Would You Rather?")
                            .font(DesignTokens.Typography.display)
                            .multilineTextAlignment(.center)
                            .accessibilityAddTraits(.isHeader)

                        Text("Pick a side.")
                            .font(DesignTokens.Typography.subtitle)
                    }
                    .foregroundStyle(.white)

                    Button("Play Now") {}
                        .buttonStyle(PrimaryButtonStyle())
                        .accessibilityHint("Gameplay will be added in the next batch.")

                    Spacer()
                }
                .padding(DesignTokens.Spacing.extraLarge)
            }
            .navigationBarHidden(true)
        }
        .accessibilityIdentifier("home-screen")
    }
}

private struct PlaceholderView: View {
    let title: String
    let message: String

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: "sparkles",
            description: Text(message)
        )
        .navigationTitle(title)
    }
}

#Preview {
    AppShellView()
        .environment(AppRouter())
}
