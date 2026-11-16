import XCTest
@testable import WouldYouRather

final class QuestionTests: XCTestCase {
    func testQuestionAcceptsPercentagesThatTotalOneHundred() {
        let question = Question(
            id: UUID(),
            category: .travel,
            optionA: "Visit the future",
            optionB: "Visit the past",
            percentageA: 52,
            percentageB: 48,
            difficulty: .easy
        )

        XCTAssertTrue(question.hasValidPercentages)
    }

    func testQuestionRejectsPercentagesThatDoNotTotalOneHundred() {
        let question = Question(
            id: UUID(),
            category: .food,
            optionA: "Only sweet food",
            optionB: "Only savory food",
            percentageA: 61,
            percentageB: 38,
            difficulty: .medium
        )

        XCTAssertFalse(question.hasValidPercentages)
    }
}
