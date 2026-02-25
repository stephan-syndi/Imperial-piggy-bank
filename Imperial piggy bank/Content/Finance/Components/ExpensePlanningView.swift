//
//  ExpensePlanningView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct ExpensePlanningView: View {
    let selectedPeriod: TimePeriod
    let plannedExpenses: [PlannedExpense]
    let currencySymbol: String
    let onOpenPlanner: () -> Void
    @EnvironmentObject var localization: LocalizationManager
    
    var periodTitle: String {
        switch localization.currentLanguage {
        case .russian:
            switch selectedPeriod {
            case .day: return "Детальное планирование"
            case .week: return "Крупные траты"
            case .month: return "Основные траты"
            }
        case .english:
            switch selectedPeriod {
            case .day: return "Detailed Planning"
            case .week: return "Major Expenses"
            case .month: return "Main Expenses"
            }
        case .german:
            switch selectedPeriod {
            case .day: return "Detaillierte Planung"
            case .week: return "Größere Ausgaben"
            case .month: return "Hauptausgaben"
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Планируемые траты")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("\(plannedExpenses.count) позиций")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal)
            
            Button(action: onOpenPlanner) {
                HStack {
                    Image(systemName: "calendar.badge.plus")
                        .font(.title2)
                    Text(periodTitle)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.pink, Color.orange]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .purple.opacity(0.5), radius: 12, x: 0, y: 6)
            }
            .padding(.horizontal)
            
            // Список запланированных трат
            if !plannedExpenses.isEmpty {
                VStack(spacing: 8) {
                    ForEach(plannedExpenses.prefix(3)) { expense in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(expense.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                if let date = expense.date, selectedPeriod == .day {
                                    Text(date, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.textSecondary)
                                } else {
                                    Text(expense.category)
                                        .font(.caption)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                            Spacer()
                            Text(String(format: "%.0f \(currencySymbol)", expense.amount))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.purple)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.secondaryCardBackground,
                                    Color.adaptivePurple.opacity(0.08)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.adaptivePurple.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    if plannedExpenses.count > 3 {
                        Button(action: onOpenPlanner) {
                            Text("Показать все (\(plannedExpenses.count))")
                                .font(.subheadline)
                                .foregroundColor(.purple)
                        }
                    }
                }
                .padding()
                .background(
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color.adaptivePurple.opacity(0.1),
                                Color.pink.opacity(0.1)
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
                        .stroke(
                            LinearGradient(
                                colors: [Color.purple.opacity(0.3), Color.pink.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: .purple.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ExpensePlanningView(
        selectedPeriod: .day,
        plannedExpenses: [],
        currencySymbol: "₽",
        onOpenPlanner: {}
    )
}
