//
//  GoalsHistorySheet.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import SwiftUI

struct GoalsHistorySheet: View {
    @Environment(\.dismiss) var dismiss
    let completedGoals: [CompletedGoal]
    let currencySymbol: String
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        NavigationView {
            Group {
                if completedGoals.isEmpty {
                    emptyHistoryView
                } else {
                    List {
                        ForEach(completedGoals) { goal in
                            GoalHistoryRow(goal: goal, currencySymbol: currencySymbol)
                        }
                    }
                }
            }
            .navigationTitle(localization.sheets.savingsHistory)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localization.sheets.done) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var emptyHistoryView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text(localization.sheets.historyEmpty)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(localization.sheets.completeFirstGoal)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct GoalHistoryRow: View {
    let goal: CompletedGoal
    let currencySymbol: String
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.headline)
                    
                    Text(goal.formattedCompletedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(goal.achievedAmount)) \(currencySymbol)")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    Text("\(goal.durationInDays) \(localization.sheets.days)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if goal.achievedAmount != goal.targetAmount {
                HStack {
                    Text("\(localization.sheets.goal) \(Int(goal.targetAmount)) \(currencySymbol)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    let overAmount = goal.achievedAmount - goal.targetAmount
                    if overAmount > 0 {
                        Text("\(localization.sheets.exceeded) +\(Int(overAmount)) \(currencySymbol)")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    GoalsHistorySheet(
        completedGoals: [
            CompletedGoal(
                title: "MacBook Pro",
                targetAmount: 100000,
                achievedAmount: 105000,
                startDate: Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date(),
                completedDate: Date()
            ),
            CompletedGoal(
                title: "Отпуск",
                targetAmount: 50000,
                achievedAmount: 50000,
                startDate: Calendar.current.date(byAdding: .day, value: -60, to: Date()) ?? Date(),
                completedDate: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date()
            )
        ],
        currencySymbol: "₽"
    )
}
