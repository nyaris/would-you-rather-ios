import Foundation

enum Choice: String, Codable {
    case optionA
    case optionB
}

struct UserAnswer: Identifiable, Codable, Hashable {
    let id: UUID
    let questionID: UUID
    let choice: Choice
    let answeredAt: Date
}

struct UserStatistics: Codable, Equatable {
    var totalAnswers = 0
    var majorityChoices = 0
    var minorityChoices = 0
    var currentStreak = 0
    var longestStreak = 0
}

struct Achievement: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let detail: String
    var isUnlocked: Bool
}

struct AppSettings: Codable, Equatable {
    var soundEffectsEnabled = true
    var hapticsEnabled = true
    var animationsEnabled = true
    var highContrastEnabled = false
}
