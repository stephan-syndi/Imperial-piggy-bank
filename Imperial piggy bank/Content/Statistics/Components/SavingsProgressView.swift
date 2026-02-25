//
//  SavingsProgressView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 20.02.26.
//

import SwiftUI

struct SavingsProgressView: View {
    let savingsGoal: SavingsGoal?
    let currencySymbol: String
    let onEdit: () -> Void
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label(localization.piggyBank.title, systemImage: "piggybank.fill")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button(action: onEdit) {
                    Image(systemName: savingsGoal == nil ? "plus.circle.fill" : "pencil.circle.fill")
                        .font(.title3)
                        .foregroundColor(.adaptiveBlue)
                }
            }
            
            if let goal = savingsGoal {
                VStack(alignment: .leading, spacing: 12) {
                    // Заголовок цели
                    Text(goal.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    // Прогресс бар
                    VStack(alignment: .leading, spacing: 8) {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Фон
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.progressTrack)
                                    .frame(height: 28)
                                
                                // Прогресс
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        LinearGradient(
                                            colors: [.green, .mint, .cyan],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(
                                        width: geometry.size.width * CGFloat(goal.progressPercentage / 100),
                                        height: 28
                                    )
                                    .shadow(color: .green.opacity(0.5), radius: 5)
                                
                                // Процент
                                Text("\(Int(goal.progressPercentage))%")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 28)
                        
                        HStack {
                            let safeCurrentAmount = goal.currentAmount.isNaN || goal.currentAmount.isInfinite ? 0 : goal.currentAmount
                            Text("\(Int(safeCurrentAmount)) \(currencySymbol)")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                            Spacer()
                            let safeTargetAmount = goal.targetAmount.isNaN || goal.targetAmount.isInfinite ? 0 : goal.targetAmount
                            Text("\(Int(safeTargetAmount)) \(currencySymbol)")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    // Статистика
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(localization.statistics.remainingToSave)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            let safeRemainingAmount = goal.remainingAmount.isNaN || goal.remainingAmount.isInfinite ? 0 : goal.remainingAmount
                            Text("\(Int(safeRemainingAmount)) \(currencySymbol)")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(localization.statistics.daysToGoal)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            Text("\(goal.daysRemaining)")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                        }
                    }
                    .padding(.top, 4)
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "piggybank")
                        .font(.system(size: 50))
                        .foregroundColor(.textTertiary)
                    
                    Text(localization.statistics.setSavingsGoal)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Button(action: onEdit) {
                        Text(localization.statistics.addGoal)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(Color.adaptiveBlue)
                            .cornerRadius(20)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 20) {
        // С целью
        SavingsProgressView(
            savingsGoal: SavingsGoal(
                targetAmount: 100000,
                currentAmount: 45000,
                deadline: Date().addingTimeInterval(60 * 60 * 24 * 90),
                title: "MacBook Pro"
            ),
            currencySymbol: "₽",
            onEdit: {}
        )
        
        // Без цели
        SavingsProgressView(
            savingsGoal: nil,
            currencySymbol: "₽",
            onEdit: {}
        )
    }
    .padding()
    .background(Color.inputFieldBackground)
    .environmentObject(LocalizationManager.shared)
}
