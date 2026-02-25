//
//  ColorExtensions.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import SwiftUI

extension Color {
    /// Конвертирует Color в hex строку
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components else {
            return "#000000"
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
    
    /// Создает Color из hex строки
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
    
    // MARK: - Адаптивные цвета для темной темы
    
    /// Цвет фона для карточек, адаптируется под тему
    static var cardBackground: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.15, alpha: 0.85)  // Темный фон с прозрачностью
                : UIColor(white: 1.0, alpha: 0.75)   // Светлый фон с прозрачностью
        })
    }
    
    /// Вторичный фон для элементов
    static var secondaryCardBackground: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.2, alpha: 0.7)
                : UIColor(white: 0.95, alpha: 0.9)
        })
    }
    
    /// Цвет для прогресс-баров (пустая часть)
    static var progressTrack: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.3, alpha: 0.4)
                : UIColor(white: 0.5, alpha: 0.15)
        })
    }
    
    /// Основной текст (высокий контраст)
    static var textPrimary: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 1.0, alpha: 0.95)
                : UIColor(white: 0.1, alpha: 1.0)
        })
    }
    
    /// Вторичный текст (средний контраст)
    static var textSecondary: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.8, alpha: 0.8)
                : UIColor(white: 0.4, alpha: 1.0)
        })
    }
    
    /// Третичный текст (низкий контраст)
    static var textTertiary: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.6, alpha: 0.7)
                : UIColor(white: 0.5, alpha: 0.8)
        })
    }
    
    /// Цвет границ
    static var borderColor: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.4, alpha: 0.5)
                : UIColor(white: 0.8, alpha: 0.6)
        })
    }
    
    /// Цвет фона для полей ввода и форм
    static var inputFieldBackground: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.2, alpha: 0.6)
                : UIColor(white: 0.95, alpha: 1.0)
        })
    }
    
    /// Яркий акцентный синий с лучшим контрастом
    static var adaptiveBlue: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 1.0)
                : UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        })
    }
    
    /// Яркий зеленый
    static var adaptiveGreen: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.3, green: 0.85, blue: 0.4, alpha: 1.0)
                : UIColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 1.0)
        })
    }
    
    /// Яркий красный
    static var adaptiveRed: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
                : UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        })
    }
    
    /// Яркий желтый
    static var adaptiveYellow: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 1.0, green: 0.9, blue: 0.3, alpha: 1.0)
                : UIColor(red: 1.0, green: 0.75, blue: 0.0, alpha: 1.0)
        })
    }
    
    /// Яркий оранжевый
    static var adaptiveOrange: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 1.0, green: 0.65, blue: 0.3, alpha: 1.0)
                : UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        })
    }
    
    /// Яркий фиолетовый
    static var adaptivePurple: Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.7, green: 0.5, blue: 1.0, alpha: 1.0)
                : UIColor(red: 0.5, green: 0.3, blue: 0.9, alpha: 1.0)
        })
    }
}
