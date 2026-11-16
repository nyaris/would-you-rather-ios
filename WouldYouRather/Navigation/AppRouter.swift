import Combine

final class AppRouter: ObservableObject {
    @Published var selectedCategory: QuestionCategory = .all
    @Published var hasCompletedOnboarding = false
}
