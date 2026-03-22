//
//  MarathonTheme.swift
//  Infil
//
//  Created by Rob King on 3/22/26.
//

import SwiftUI

// MARK: - Marathon Color Palette
// Based on the Marathon game website aesthetic

extension Color {
    // Primary brand colors - vibrant cyber/neon theme
    static let marathonPrimary = Color(red: 0.0, green: 0.8, blue: 0.8) // Cyan/teal
    static let marathonSecondary = Color(red: 1.0, green: 0.0, blue: 0.5) // Hot pink/magenta
    static let marathonAccent = Color(red: 0.0, green: 1.0, blue: 0.6) // Neon green
    
    // Background colors - dark, moody palette
    static let marathonBackground = Color(red: 0.05, green: 0.05, blue: 0.1) // Deep blue-black
    static let marathonSurface = Color(red: 0.1, green: 0.1, blue: 0.15) // Slightly lighter surface
    static let marathonCard = Color(red: 0.12, green: 0.12, blue: 0.18) // Card background
    
    // UI element colors
    static let marathonBorder = Color(red: 0.2, green: 0.25, blue: 0.35) // Subtle border
    static let marathonHighlight = Color(red: 0.15, green: 0.6, blue: 0.8) // Blue highlight
    
    // Status colors
    static let marathonSuccess = Color(red: 0.0, green: 0.9, blue: 0.5) // Success green
    static let marathonWarning = Color(red: 1.0, green: 0.6, blue: 0.0) // Warning orange
    static let marathonDanger = Color(red: 1.0, green: 0.2, blue: 0.3) // Danger red
    
    // Text colors
    static let marathonTextPrimary = Color.white
    static let marathonTextSecondary = Color(red: 0.7, green: 0.75, blue: 0.8)
    static let marathonTextTertiary = Color(red: 0.5, green: 0.55, blue: 0.6)
}

// MARK: - Marathon Typography

struct MarathonFontStyle {
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
    static let title = Font.system(size: 28, weight: .bold, design: .default)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .default)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
    static let headline = Font.system(size: 17, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
}

// MARK: - Marathon Button Styles

struct MarathonPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(MarathonFontStyle.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color.marathonPrimary, Color.marathonHighlight],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.marathonPrimary.opacity(0.5), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct MarathonSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(MarathonFontStyle.headline)
            .foregroundStyle(Color.marathonPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.marathonSurface)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.marathonPrimary.opacity(0.5), lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Marathon Card Style

struct MarathonCardModifier: ViewModifier {
    var glowColor: Color = .marathonPrimary
    
    func body(content: Content) -> some View {
        content
            .background(Color.marathonCard)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [glowColor.opacity(0.3), glowColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: glowColor.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

extension View {
    func marathonCard(glowColor: Color = .marathonPrimary) -> some View {
        modifier(MarathonCardModifier(glowColor: glowColor))
    }
}

// MARK: - Marathon Section Header Style

struct MarathonSectionHeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(MarathonFontStyle.caption)
            .foregroundStyle(Color.marathonPrimary)
            .textCase(.uppercase)
            .tracking(1.2)
    }
}

extension View {
    func marathonSectionHeader() -> some View {
        modifier(MarathonSectionHeaderModifier())
    }
}

// MARK: - Marathon Resource Tag Style

struct MarathonResourceTag: View {
    let text: String
    let color: Color
    
    init(_ text: String, color: Color = .marathonPrimary) {
        self.text = text
        self.color = color
    }
    
    var body: some View {
        Text(text)
            .font(MarathonFontStyle.caption)
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(color.opacity(0.2))
                    .overlay(
                        Capsule()
                            .stroke(color.opacity(0.5), lineWidth: 1)
                    )
            )
    }
}

// MARK: - Marathon Shell Icon Style

struct MarathonShellIcon: View {
    let shell: String
    let size: CGFloat
    
    init(shell: String, size: CGFloat = 24) {
        self.shell = shell
        self.size = size
    }
    
    var body: some View {
        Image(systemName: shellIcon(for: shell))
            .font(.system(size: size * 0.6))
            .foregroundStyle(Color.marathonPrimary)
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(Color.marathonSurface)
                    .overlay(
                        Circle()
                            .stroke(Color.marathonPrimary.opacity(0.4), lineWidth: 1)
                    )
            )
    }
    
    private func shellIcon(for shell: String) -> String {
        switch shell.lowercased() {
        case "triage": return "cross.case.fill"
        case "vandal": return "flame.fill"
        case "thief": return "hand.raised.slash"
        case "destroyer": return "burst.fill"
        case "assassin": return "scope"
        case "recon": return "eye.fill"
        default: return "eye.fill"
        }
    }
}

// MARK: - Marathon Navigation Bar Appearance

extension View {
    func marathonNavigationBar() -> some View {
        self
            .toolbarBackground(Color.marathonBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Marathon Background

struct MarathonBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.marathonBackground
                .ignoresSafeArea()
            
            content
        }
    }
}

extension View {
    func marathonBackground() -> some View {
        modifier(MarathonBackgroundModifier())
    }
}
