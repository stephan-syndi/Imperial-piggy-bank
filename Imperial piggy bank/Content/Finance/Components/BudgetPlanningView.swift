//
//  BudgetPlanningView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct BudgetPlanningView: View {
    let budget: Double
    let periodLabel: String
    let currencySymbol: String
    let onEdit: () -> Void
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("\(localization.finance.budgetPlanning) на \(periodLabel)")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Button(action: onEdit) {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil.circle.fill")
                        Text(localization.finance.editBudget)
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(localization.finance.budget)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                        Text(String(format: "%.0f \(currencySymbol)", budget))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.adaptiveBlue)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.largeTitle)
                        .foregroundColor(.blue.opacity(0.3))
                }
            }
            .padding()
            .background(
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.adaptiveBlue.opacity(0.15),
                            Color.cyan.opacity(0.15),
                            Color.adaptiveGreen.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    // Декоративные круги
                    Circle()
                        .fill(Color.cardBackground.opacity(0.5))
                        .frame(width: 80, height: 80)
                        .offset(x: 100, y: -20)
                        .blur(radius: 15)
                }
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.borderColor, lineWidth: 1.5)
            )
            .shadow(color: Color.adaptiveBlue.opacity(0.2), radius: 12, x: 0, y: 6)
            .padding(.horizontal)
        }
    }
}

#Preview {
    BudgetPlanningView(budget: 5000, periodLabel: "день", currencySymbol: "₽", onEdit: {})
}
