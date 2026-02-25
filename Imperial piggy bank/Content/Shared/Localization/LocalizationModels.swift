//
//  LocalizationModels.swift
//  Imperial piggy bank
//
//  Created on 25.02.26.
//

import Foundation

/// Поддерживаемые языки приложения
enum AppLanguage: String, CaseIterable, Codable {
    case russian = "Русский"
    case english = "English"
    case german = "Deutsch"
    
    var code: String {
        switch self {
        case .russian: return "ru"
        case .english: return "en"
        case .german: return "de"
        }
    }
    
    var displayName: String {
        return self.rawValue
    }
}
