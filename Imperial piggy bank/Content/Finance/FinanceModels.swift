//
//  FinanceModels.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 5.02.26.
//

import Foundation
import SwiftUI

enum TimePeriod: String, CaseIterable {
    case day = "День"
    case week = "Неделя"
    case month = "Месяц"
    
    var label: String {
        switch self {
        case .day: return "день"
        case .week: return "неделю"
        case .month: return "месяц"
        }
    }
}

struct Expense: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let category: String
    let date: Date
}

struct PlannedExpense: Identifiable {
    let id: UUID
    var title: String
    var amount: Double
    var category: String
    var date: Date?
    
    init(id: UUID = UUID(), title: String, amount: Double, category: String, date: Date? = nil) {
        self.id = id
        self.title = title
        self.amount = amount
        self.category = category
        self.date = date
    }
}

enum ExpenseCategory: String, CaseIterable {
    case food
    case transport
    case entertainment
    case shopping
    case other
    
    /// Возвращает локализованное название категории
    func localizedName(using localization: LocalizationManager) -> String {
        switch self {
        case .food: return localization.categories.food
        case .transport: return localization.categories.transport
        case .entertainment: return localization.categories.entertainment
        case .shopping: return localization.categories.shopping
        case .other: return localization.categories.other
        }
    }
    
    /// Возвращает иконку для категории
    var icon: String {
        switch self {
        case .food: return "cart.fill"
        case .transport: return "bus.fill"
        case .entertainment: return "gamecontroller.fill"
        case .shopping: return "bag.fill"
        case .other: return "questionmark.circle.fill"
        }
    }
    
    /// Возвращает цвет для категории
    var color: Color {
        switch self {
        case .food: return .orange
        case .transport: return .blue
        case .entertainment: return .purple
        case .shopping: return .pink
        case .other: return .gray
        }
    }
    
    /// Создает ExpenseCategory из локализованного названия
    static func from(localizedName: String, using localization: LocalizationManager) -> ExpenseCategory {
        switch localizedName {
        case localization.categories.food: return .food
        case localization.categories.transport: return .transport
        case localization.categories.entertainment: return .entertainment
        case localization.categories.shopping: return .shopping
        default: return .other
        }
    }
}
