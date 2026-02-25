//
//  BudgetCardView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct BudgetCardView: View {
    let budgetInfo: BudgetInfo
    let currencySymbol: String
    let onFinanceTap: () -> Void
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(localization.main.todayBudget)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Button(action: onFinanceTap) {
                    HStack(spacing: 4) {
                        Text(localization.finance.title)
                            .font(.subheadline)
                        Image(systemName: "arrow.right")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }
            }
            
            // Прогресс бар бюджета
            VStack(spacing: 8) {
                HStack {
                    BudgetInfoItem(
                        label: localization.finance.budget,
                        value: budgetInfo.dailyBudget,
                        currencySymbol: currencySymbol,
                        color: .textPrimary
                    )
                    
                    Spacer()
                    
                    BudgetInfoItem(
                        label: localization.main.spent,
                        value: budgetInfo.spent,
                        currencySymbol: currencySymbol,
                        color: .adaptiveRed
                    )
                    
                    Spacer()
                    
                    BudgetInfoItem(
                        label: localization.main.remaining,
                        value: budgetInfo.remaining,
                        currencySymbol: currencySymbol,
                        color: .adaptiveGreen
                    )
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.progressTrack)
                            .frame(height: 16)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.adaptiveGreen, Color.adaptiveYellow, Color.adaptiveOrange, Color.adaptiveRed]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * budgetInfo.spentPercentage, height: 16)
                            .shadow(color: Color.adaptiveGreen.opacity(0.5), radius: 5)
                    }
                }
                .frame(height: 16)
            }
        }
        .padding()
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color.adaptiveBlue.opacity(0.15),
                        Color.adaptivePurple.opacity(0.15),
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
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.borderColor, lineWidth: 1.5)
        )
        .shadow(color: Color.adaptiveBlue.opacity(0.2), radius: 12, x: 0, y: 6)
    }
}

struct BudgetInfoItem: View {
    let label: String
    let value: Double
    let currencySymbol: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
            Text(String(format: "%.0f \(currencySymbol)", value))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}
