//
//  OnboardingModels.swift
//  Imperial piggy bank
//
//  Created on 25.02.26.
//

import Foundation

/// Структура для хранения регионов
enum Region: String, CaseIterable, Codable {
    case russia = "Россия"
    case usa = "США"
    case uk = "Великобритания"
    case germany = "Германия"
    case france = "Франция"
    case spain = "Испания"
    case italy = "Италия"
    case poland = "Польша"
    case ukraine = "Украина"
    case belarus = "Беларусь"
    case kazakhstan = "Казахстан"
    case other = "Другое"
    
    /// Валюта по умолчанию для региона
    var defaultCurrency: Currency {
        switch self {
        case .russia:
            return .ruble
        case .usa:
            return .dollar
        case .uk:
            return .pound
        case .germany, .france, .spain, .italy:
            return .euro
        case .poland:
            return .euro
        case .ukraine, .belarus, .kazakhstan:
            return .ruble
        case .other:
            return .dollar
        }
    }
}

/// Состояние процесса онбординга
enum OnboardingStep: Int {
    case welcome = 0
    case personalInfo = 1
    case regionAndCurrency = 2
    case complete = 3
}
