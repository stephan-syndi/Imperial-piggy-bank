//
//  StatisticsModels.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI
import Foundation

struct CategoryExpense: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
    let icon: String
}

struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let amount: Double
    let date: Date
    let icon: String
    let color: Color
}

struct SavingsGoal: Identifiable, Codable {
    let id: UUID
    var targetAmount: Double
    var currentAmount: Double
    var deadline: Date
    var title: String
    
    init(id: UUID = UUID(), targetAmount: Double, currentAmount: Double = 0, deadline: Date, title: String) {
        self.id = id
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.deadline = deadline
        self.title = title
    }
    
    var progressPercentage: Double {
        guard targetAmount > 0 else { return 0 }
        return min((currentAmount / targetAmount) * 100, 100)
    }
    
    var remainingAmount: Double {
        return max(targetAmount - currentAmount, 0)
    }
    
    var daysRemaining: Int {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: Date(), to: deadline).day ?? 0
        return max(days, 0)
    }
}
