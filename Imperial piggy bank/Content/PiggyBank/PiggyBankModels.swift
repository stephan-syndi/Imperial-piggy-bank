//
//  PiggyBankModels.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import Foundation
import SwiftUI

/// Ежедневное накопление в копилке
struct DailySaving: Identifiable, Codable {
    let id: UUID
    let date: Date
    let amount: Double
    let note: String?
    
    init(id: UUID = UUID(), date: Date, amount: Double, note: String? = nil) {
        self.id = id
        self.date = date
        self.amount = amount
        self.note = note
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}

/// Завершенная цель накоплений (история)
struct CompletedGoal: Identifiable, Codable {
    let id: UUID
    let title: String
    let targetAmount: Double
    let achievedAmount: Double
    let startDate: Date
    let completedDate: Date
    
    init(id: UUID = UUID(), title: String, targetAmount: Double, achievedAmount: Double, startDate: Date, completedDate: Date = Date()) {
        self.id = id
        self.title = title
        self.targetAmount = targetAmount
        self.achievedAmount = achievedAmount
        self.startDate = startDate
        self.completedDate = completedDate
    }
    
    var durationInDays: Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: startDate, to: completedDate).day ?? 0
    }
    
    var formattedCompletedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: completedDate)
    }
}

/// Расширение для SavingsGoal с дополнительными вычисляемыми свойствами
extension SavingsGoal {
    /// Средняя сумма накопления в день
    var averageDailyAmount: Double {
        guard daysRemaining > 0, remainingAmount > 0 else { return 0 }
        return remainingAmount / Double(daysRemaining)
    }
    
    /// Рекомендуемая сумма накопления в день
    var recommendedDailyAmount: Double {
        return averageDailyAmount
    }
    
    /// Дата начала (вычисляется от дедлайна назад)
    var startDate: Date {
        let totalDays = Calendar.current.dateComponents([.day], from: Date(), to: deadline).day ?? 0
        return Calendar.current.date(byAdding: .day, value: -totalDays, to: deadline) ?? Date()
    }
}
