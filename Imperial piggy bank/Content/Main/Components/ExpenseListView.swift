//
//  ExpenseListView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct ExpenseListView: View {
    let expenses: [DailyExpense]
    let currencySymbol: String
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localization.main.activities)
                .font(.headline)
                .fontWeight(.bold)
            
            if expenses.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "cart")
                        .font(.system(size: 40))
                        .foregroundColor(.textSecondary)
                    
                    Text(localization.main.noExpenses)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text(localization.main.addFirstExpenseHint)
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            } else {
                VStack(spacing: 8) {
                    ForEach(expenses) { expense in
                        ExpenseRowView(expense: expense, currencySymbol: currencySymbol)
                    }
                }
            }
        }
        .padding()
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color.adaptiveRed.opacity(0.1),
                        Color.adaptiveOrange.opacity(0.1)
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
        .shadow(color: Color.adaptiveRed.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

struct ExpenseRowView: View {
    let expense: DailyExpense
    let currencySymbol: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: expense.icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(expense.color)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(expense.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(expense.time)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Text("-\(String(format: "%.0f", expense.amount)) \(currencySymbol)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.adaptiveRed)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color.secondaryCardBackground,
                    expense.color.opacity(0.08)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(expense.color.opacity(0.3), lineWidth: 1)
        )
    }
}
