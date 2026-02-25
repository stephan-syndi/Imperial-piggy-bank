//
//  CategoryExpenseChart.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI
import Charts

struct CategoryExpenseChart: View {
    let categoryExpenses: [CategoryExpense]
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localization.statistics.categoryExpenses)
                .font(.headline)
            
            if #available(iOS 17.0, *) {
                Chart(categoryExpenses) { category in
                    SectorMark(
                        angle: .value("Сумма", category.amount),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(category.color)
                    .cornerRadius(4)
                }
                .frame(height: 200)
            } else {
                // Горизонтальная диаграмма для iOS 16
                Chart(categoryExpenses) { category in
                    BarMark(
                        x: .value("Сумма", category.amount),
                        y: .value("Категория", category.name)
                    )
                    .foregroundStyle(category.color)
                    .cornerRadius(6)
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(position: .bottom)
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    CategoryExpenseChart(categoryExpenses: [
        CategoryExpense(name: "Еда", amount: 450, color: .orange, icon: "fork.knife"),
        CategoryExpense(name: "Транспорт", amount: 200, color: .blue, icon: "car.fill")
    ])
    .environmentObject(LocalizationManager.shared)
}
