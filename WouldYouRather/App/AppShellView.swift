import Combine
import SwiftUI

struct AppShellView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack { CategorySelectionView() }
                .tabItem { Label("Categories", systemImage: "square.grid.2x2.fill") }

            NavigationStack {
                PlaceholderView(title: "Statistics", message: "Your progress and streaks will appear here.")
            }
            .tabItem { Label("Statistics", systemImage: "chart.bar.fill") }

            NavigationStack {
                PlaceholderView(title: "Settings", message: "Game preferences will be available here.")
            }
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .accessibilityIdentifier("main-tab-view")
    }
}

private struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var isPresentingGame = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [AppColor.red, AppColor.blue], startPoint: .top, endPoint: .bottom)
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

                    Button("Play Now") { isPresentingGame = true }
                        .buttonStyle(PrimaryButtonStyle())
                        .accessibilityIdentifier("play-now-button")

                    Text(router.selectedCategory == .all ? "Random questions" : router.selectedCategory.title)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))

                    Spacer()
                }
                .padding(DesignTokens.Spacing.extraLarge)
            }
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $isPresentingGame) {
            GameplayView(category: router.selectedCategory)
        }
        .accessibilityIdentifier("home-screen")
    }
}

private struct CategorySelectionView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        List(QuestionCategory.allCases) { category in
            Button {
                router.selectedCategory = category
            } label: {
                HStack(spacing: DesignTokens.Spacing.medium) {
                    Image(systemName: category.symbolName)
                        .foregroundStyle(category.tint)
                        .frame(width: 28)
                    Text(category.title)
                    Spacer()
                    if router.selectedCategory == category {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(AppColor.blue)
                    }
                }
            }
            .accessibilityLabel(category.title)
            .accessibilityValue(router.selectedCategory == category ? "Selected" : "Not selected")
        }
        .navigationTitle("Categories")
    }
}

private struct GameplayView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @StateObject private var game: GameViewModel

    init(category: QuestionCategory) {
        _game = StateObject(wrappedValue: GameViewModel(category: category))
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    ChoicePanel(
                        title: game.currentQuestion.optionA,
                        percentage: game.currentQuestion.percentageA,
                        color: AppColor.red,
                        isSelected: game.selectedChoice == .optionA,
                        revealResult: game.hasAnswered,
                        action: { game.answer(.optionA) }
                    )
                    .frame(height: proxy.size.height * 0.5)

                    ChoicePanel(
                        title: game.currentQuestion.optionB,
                        percentage: game.currentQuestion.percentageB,
                        color: AppColor.blue,
                        isSelected: game.selectedChoice == .optionB,
                        revealResult: game.hasAnswered,
                        action: { game.answer(.optionB) }
                    )
                    .frame(height: proxy.size.height * 0.5)
                }

                Rectangle()
                    .fill(AppColor.ink)
                    .frame(height: 10)
                    .accessibilityHidden(true)

                Circle()
                    .fill(AppColor.ink)
                    .frame(width: 74, height: 74)
                    .overlay(Circle().stroke(.white, lineWidth: 4).frame(width: 22, height: 22))
                    .accessibilityHidden(true)

                VStack {
                    HStack {
                        Button("Close", systemImage: "xmark") { dismiss() }
                            .labelStyle(.iconOnly)
                            .font(.headline)
                            .padding(12)
                            .background(.black.opacity(0.25), in: Circle())
                            .accessibilityLabel("Close game")
                        Spacer()
                        Text("\(game.questionNumber) / \(game.questions.count)")
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.black.opacity(0.25), in: Capsule())
                    }
                    .foregroundStyle(.white)
                    .padding()

                    Spacer()

                    if game.hasAnswered {
                        VStack(spacing: 12) {
                            Text(game.resultMessage)
                                .font(.headline.weight(.bold))
                                .multilineTextAlignment(.center)
                            Button("Next Question") { game.next() }
                                .buttonStyle(PrimaryButtonStyle())
                                .accessibilityIdentifier("next-question-button")
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .background(.black.opacity(0.7), in: RoundedRectangle(cornerRadius: 24))
                        .padding(.horizontal, DesignTokens.Spacing.large)
                        .transition(reduceMotion ? .opacity : .move(edge: .bottom).combined(with: .opacity))
                    }

                    Spacer().frame(height: 24)
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .animation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.82), value: game.hasAnswered)
    }
}

private struct ChoicePanel: View {
    let title: String
    let percentage: Int
    let color: Color
    let isSelected: Bool
    let revealResult: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 18) {
                Text(title)
                    .font(.system(size: 25, weight: .black, design: .rounded))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(4)

                if revealResult {
                    Text("\(percentage)%")
                        .font(.system(size: 56, weight: .black, design: .rounded))
                        .contentTransition(.numericText())
                } else {
                    Text("Choose this side")
                        .font(.headline)
                }
            }
            .foregroundStyle(.white)
            .padding(DesignTokens.Spacing.extraLarge)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color.opacity(isSelected ? 1 : 0.92))
            .overlay {
                if isSelected {
                    Rectangle().stroke(.white, lineWidth: 5)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(revealResult)
        .accessibilityLabel(title)
        .accessibilityHint(revealResult ? "This option received \(percentage) percent of votes." : "Double tap to choose this option.")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

private final class GameViewModel: ObservableObject {
    let questions: [Question]
    @Published private(set) var currentIndex = 0
    @Published private(set) var selectedChoice: Choice?

    init(category: QuestionCategory) {
        let filtered = SampleQuestions.items.filter { category == .all || $0.category == category }
        questions = filtered.isEmpty ? SampleQuestions.items : filtered
    }

    var currentQuestion: Question { questions[currentIndex] }
    var hasAnswered: Bool { selectedChoice != nil }
    var questionNumber: Int { currentIndex + 1 }

    var resultMessage: String {
        guard let selectedChoice else { return "" }
        let percentage = selectedChoice == .optionA ? currentQuestion.percentageA : currentQuestion.percentageB
        if percentage > 50 { return "You think like the majority!" }
        if percentage < 50 { return "You are officially in the minority!" }
        return "Perfectly split decision!"
    }

    func answer(_ choice: Choice) {
        guard selectedChoice == nil else { return }
        selectedChoice = choice
    }

    func next() {
        currentIndex = (currentIndex + 1) % questions.count
        selectedChoice = nil
    }
}

private enum SampleQuestions {
    static let items: [Question] = [
        .init(id: UUID(), category: .travel, optionA: "Spend two months in France with all expenses paid", optionB: "Spend one hour walking on the Moon", percentageA: 51, percentageB: 49, difficulty: .medium),
        .init(id: UUID(), category: .technology, optionA: "Be able to talk to every device", optionB: "Never need to charge a device again", percentageA: 44, percentageB: 56, difficulty: .easy),
        .init(id: UUID(), category: .food, optionA: "Eat only sweet food forever", optionB: "Eat only savory food forever", percentageA: 47, percentageB: 53, difficulty: .easy),
        .init(id: UUID(), category: .entertainment, optionA: "Live without music", optionB: "Live without movies", percentageA: 38, percentageB: 62, difficulty: .hard),
        .init(id: UUID(), category: .everydayLife, optionA: "Always be ten minutes early", optionB: "Always be ten minutes late", percentageA: 81, percentageB: 19, difficulty: .easy),
        .init(id: UUID(), category: .absurdSituations, optionA: "Have a tiny elephant as a pet", optionB: "Have a friendly dragon as a pet", percentageA: 29, percentageB: 71, difficulty: .medium)
    ]
}

private struct PlaceholderView: View {
    let title: String
    let message: String

    var body: some View {
        ContentUnavailableView(title, systemImage: "sparkles", description: Text(message))
            .navigationTitle(title)
    }
}

private extension QuestionCategory {
    var symbolName: String {
        switch self {
        case .all: "shuffle"
        case .travel: "airplane"
        case .food: "fork.knife"
        case .everydayLife: "sun.max.fill"
        case .relationships: "heart.fill"
        case .workAndSchool: "briefcase.fill"
        case .entertainment: "film.fill"
        case .technology: "laptopcomputer"
        case .difficultChoices: "scale.3d"
        case .absurdSituations: "sparkles"
        }
    }

    var tint: Color {
        switch self {
        case .all, .technology: AppColor.blue
        case .food, .relationships: AppColor.red
        default: AppColor.ink
        }
    }
}

struct AppShellView_Previews: PreviewProvider {
    static var previews: some View {
        AppShellView().environmentObject(AppRouter())
    }
}
