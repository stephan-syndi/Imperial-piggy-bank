//
//  SettingsModels.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import Foundation
import SwiftUI
import Combine

/// Режим оформления приложения
enum AppearanceMode: String, CaseIterable, Codable {
    case system
    case light
    case dark
}

/// Валюты, поддерживаемые приложением
enum Currency: String, CaseIterable, Codable {
    case ruble
    case dollar
    case euro
    case pound
    
    var symbol: String {
        switch self {
        case .ruble: return "₽"
        case .dollar: return "$"
        case .euro: return "€"
        case .pound: return "£"
        }
    }
}

/// Модель настроек пользователя
class UserSettingsModel: ObservableObject, Codable {
    // MARK: - Профиль пользователя
    @Published var firstName: String
    @Published var lastName: String
    @Published var region: String
    @Published var currency: Currency
    @Published var language: AppLanguage
    
    // MARK: - Внешний вид
    @Published var appearanceMode: AppearanceMode
    
    // MARK: - Уведомления
    @Published var dailySummaryEnabled: Bool
    @Published var dailySummaryTime: Date
    
    // MARK: - Дополнительная информация
    let appVersion: String = "1.0.0"
    
    // MARK: - Computed Properties
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
    
    // MARK: - Инициализация
    init(
        firstName: String = "",
        lastName: String = "",
        region: String = "",
        currency: Currency = .ruble,
        language: AppLanguage = .english,
        appearanceMode: AppearanceMode = .system,
        dailySummaryEnabled: Bool = true,
        dailySummaryTime: Date = Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? Date()
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.region = region
        self.currency = currency
        self.language = language
        self.appearanceMode = appearanceMode
        self.dailySummaryEnabled = dailySummaryEnabled
        self.dailySummaryTime = dailySummaryTime
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, region, currency, language
        case appearanceMode, dailySummaryEnabled, dailySummaryTime
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        region = try container.decode(String.self, forKey: .region)
        currency = try container.decode(Currency.self, forKey: .currency)
        language = try container.decodeIfPresent(AppLanguage.self, forKey: .language) ?? .russian
        appearanceMode = try container.decode(AppearanceMode.self, forKey: .appearanceMode)
        dailySummaryEnabled = try container.decode(Bool.self, forKey: .dailySummaryEnabled)
        dailySummaryTime = try container.decode(Date.self, forKey: .dailySummaryTime)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(region, forKey: .region)
        try container.encode(currency, forKey: .currency)
        try container.encode(language, forKey: .language)
        try container.encode(appearanceMode, forKey: .appearanceMode)
        try container.encode(dailySummaryEnabled, forKey: .dailySummaryEnabled)
        try container.encode(dailySummaryTime, forKey: .dailySummaryTime)
    }
}

/// Структура для ежедневной сводки
struct DailySummary {
    let date: Date
    let totalSpent: Double
    let budgetRemaining: Double
    let canTransferToPiggyBank: Bool
    
    var transferAmount: Double {
        canTransferToPiggyBank ? budgetRemaining : 0
    }
}
