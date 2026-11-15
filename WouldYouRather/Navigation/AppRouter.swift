import Observation

@Observable
final class AppRouter {
    var selectedCategory: QuestionCategory = .all
    var hasCompletedOnboarding = false
}
