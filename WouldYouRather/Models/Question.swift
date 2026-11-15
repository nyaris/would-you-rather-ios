import Foundation

enum QuestionCategory: String, CaseIterable, Codable, Identifiable {
    case all
    case travel
    case food
    case everydayLife
    case relationships
    case workAndSchool
    case entertainment
    case technology
    case difficultChoices
    case absurdSituations

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: "All Questions"
        case .travel: "Travel"
        case .food: "Food"
        case .everydayLife: "Everyday Life"
        case .relationships: "Relationships"
        case .workAndSchool: "Work and School"
        case .entertainment: "Entertainment"
        case .technology: "Technology"
        case .difficultChoices: "Difficult Choices"
        case .absurdSituations: "Absurd Situations"
        }
    }
}

enum QuestionDifficulty: String, Codable {
    case easy
    case medium
    case hard
}

struct Question: Identifiable, Codable, Hashable {
    let id: UUID
    let category: QuestionCategory
    let optionA: String
    let optionB: String
    let percentageA: Int
    let percentageB: Int
    let difficulty: QuestionDifficulty

    var hasValidPercentages: Bool {
        percentageA >= 0 && percentageB >= 0 && percentageA + percentageB == 100
    }
}
