//
//  MainModels.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import Foundation
import SwiftUI

struct BudgetInfo {
    var dailyBudget: Double
    var spent: Double
    
    var remaining: Double {
        dailyBudget - spent
    }
    
    var spentPercentage: Double {
        guard dailyBudget > 0 else { return 0 }
        return min(spent / dailyBudget, 1.0)
    }
}

struct DayStats {
    var tasksCompleted: Int
    var totalTasks: Int
    var plannedHours: Double
    
    var progress: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(tasksCompleted) / Double(totalTasks)
    }
}

struct SavingsProgress {
    var goalTitle: String
    var targetAmount: Double
    var currentAmount: Double
    var progressPercentage: Double
    var daysRemaining: Int
}
