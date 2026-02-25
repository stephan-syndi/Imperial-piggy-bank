//
//  ThemeManager.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 25.02.26.
//

import SwiftUI

/// Менеджер тем для управления цветовыми схемами приложения
struct ThemeManager {
    
    /// Типы фонов для разных экранов
    enum BackgroundType {
        case main
        case finance
        case piggyBank
        case statistics
        case settings
        case onboarding
    }
    
    /// Получить градиент фона в зависимости от темы
    static func backgroundGradient(
        for type: BackgroundType,
        appearanceMode: AppearanceMode,
        colorScheme: ColorScheme
    ) -> LinearGradient {
        
        let isDark = shouldUseDarkMode(appearanceMode: appearanceMode, colorScheme: colorScheme)
        
        return LinearGradient(
            colors: gradientColors(for: type, isDark: isDark),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Определить, нужно ли использовать темный режим
    private static func shouldUseDarkMode(appearanceMode: AppearanceMode, colorScheme: ColorScheme) -> Bool {
        switch appearanceMode {
        case .system:
            return colorScheme == .dark
        case .light:
            return false
        case .dark:
            return true
        }
    }
    
    /// Получить цвета градиента для конкретного типа фона
    private static func gradientColors(for type: BackgroundType, isDark: Bool) -> [Color] {
        if isDark {
            return darkGradientColors(for: type)
        } else {
            return lightGradientColors(for: type)
        }
    }
    
    // MARK: - Light Mode Gradients
    
    private static func lightGradientColors(for type: BackgroundType) -> [Color] {
        switch type {
        case .main:
            return [
                Color(red: 0.95, green: 0.85, blue: 1.0),
                Color(red: 0.85, green: 0.95, blue: 1.0),
                Color(red: 1.0, green: 0.95, blue: 0.85)
            ]
        case .finance:
            return [
                Color(red: 0.85, green: 1.0, blue: 0.95),
                Color(red: 0.95, green: 0.95, blue: 1.0),
                Color(red: 1.0, green: 0.90, blue: 0.95)
            ]
        case .piggyBank:
            return [
                Color(red: 1.0, green: 0.95, blue: 0.85),
                Color(red: 1.0, green: 0.85, blue: 0.7),
                Color(red: 1.0, green: 0.9, blue: 0.95)
            ]
        case .statistics:
            return [
                Color(red: 0.9, green: 0.95, blue: 1.0),
                Color(red: 0.95, green: 0.85, blue: 1.0),
                Color(red: 0.85, green: 0.95, blue: 0.95)
            ]
        case .settings:
            return [
                Color(red: 1.0, green: 0.9, blue: 0.95),
                Color(red: 0.9, green: 0.95, blue: 1.0),
                Color(red: 0.95, green: 1.0, blue: 0.9)
            ]
        case .onboarding:
            return [
                Color(red: 0.4, green: 0.6, blue: 1.0),
                Color(red: 0.6, green: 0.4, blue: 1.0),
                Color(red: 1.0, green: 0.5, blue: 0.8)
            ]
        }
    }
    
    // MARK: - Dark Mode Gradients
    
    private static func darkGradientColors(for type: BackgroundType) -> [Color] {
        switch type {
        case .main:
            return [
                Color(red: 0.1, green: 0.08, blue: 0.15),
                Color(red: 0.08, green: 0.12, blue: 0.18),
                Color(red: 0.12, green: 0.1, blue: 0.15)
            ]
        case .finance:
            return [
                Color(red: 0.08, green: 0.15, blue: 0.12),
                Color(red: 0.1, green: 0.1, blue: 0.16),
                Color(red: 0.14, green: 0.08, blue: 0.12)
            ]
        case .piggyBank:
            return [
                Color(red: 0.15, green: 0.12, blue: 0.08),
                Color(red: 0.18, green: 0.10, blue: 0.08),
                Color(red: 0.15, green: 0.10, blue: 0.12)
            ]
        case .statistics:
            return [
                Color(red: 0.09, green: 0.1, blue: 0.16),
                Color(red: 0.12, green: 0.08, blue: 0.15),
                Color(red: 0.08, green: 0.12, blue: 0.14)
            ]
        case .settings:
            return [
                Color(red: 0.14, green: 0.09, blue: 0.12),
                Color(red: 0.09, green: 0.11, blue: 0.16),
                Color(red: 0.11, green: 0.15, blue: 0.10)
            ]
        case .onboarding:
            return [
                Color(red: 0.15, green: 0.20, blue: 0.35),
                Color(red: 0.20, green: 0.15, blue: 0.35),
                Color(red: 0.30, green: 0.18, blue: 0.28)
            ]
        }
    }
}

// MARK: - View Extension

extension View {
    /// Применить тематический фон к View
    func themedBackground(
        _ type: ThemeManager.BackgroundType,
        appearanceMode: AppearanceMode,
        colorScheme: ColorScheme
    ) -> some View {
        self.background(
            ThemeManager.backgroundGradient(
                for: type,
                appearanceMode: appearanceMode,
                colorScheme: colorScheme
            )
            .ignoresSafeArea()
        )
    }
}
