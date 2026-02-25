//
//  WeeklyExpenseChart.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI
import Charts

struct WeeklyExpenseChart: View {
    let weeklyExpenses: [DailyExpense]
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localization.statistics.weeklyExpenses)
                .font(.headline)
            
            if weeklyExpenses.isEmpty {
                Text(localization.statistics.noDataYet)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 200)
            } else {
                Chart(weeklyExpenses) { expense in
                    BarMark(
                        x: .value("День", expense.time),
                        y: .value("Сумма", expense.amount)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.cyan, Color.green]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .cornerRadius(8)
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
        .padding()
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color.adaptiveBlue.opacity(0.1),
                        Color.cyan.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .blur(radius: 0.5)
            }
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderColor, lineWidth: 1.5)
        )
        .shadow(color: Color.adaptiveBlue.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    WeeklyExpenseChart(weeklyExpenses: [
        DailyExpense(time: "Пн", amount: 850),
        DailyExpense(time: "Вт", amount: 1200),
        DailyExpense(time: "Ср", amount: 950)
    ])
    .environmentObject(LocalizationManager.shared)
}
