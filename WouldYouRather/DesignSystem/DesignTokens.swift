import SwiftUI

enum AppColor {
    static let red = Color(red: 0.882, green: 0.024, blue: 0.0)
    static let blue = Color(red: 0.086, green: 0.533, blue: 0.820)
    static let ink = Color.black
    static let canvas = Color(red: 0.949, green: 0.949, blue: 0.949)
}

enum DesignTokens {
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }

    enum CornerRadius {
        static let button: CGFloat = 16
    }

    enum Typography {
        static let display = Font.system(size: 42, weight: .black, design: .rounded)
        static let subtitle = Font.system(size: 20, weight: .semibold, design: .rounded)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.bold))
            .foregroundStyle(AppColor.ink)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignTokens.Spacing.medium)
            .background(.white, in: RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.button))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
