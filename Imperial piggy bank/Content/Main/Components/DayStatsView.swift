//
//  DayStatsView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct DayStatsView: View {
    let savingsProgress: SavingsProgress?
    let currencySymbol: String
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        if let progress = savingsProgress {
            PiggyBankProgressCard(progress: progress, currencySymbol: currencySymbol)
        } else {
            EmptyPiggyBankCard()
        }
    }
}

struct PiggyBankProgressCard: View {
    let progress: SavingsProgress
    let currencySymbol: String
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "banknote.fill")
                    .font(.title2)
                    .foregroundColor(.pink)
                Text(progress.goalTitle)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            // Прогресс бар
            VStack(spacing: 8) {
                HStack {
                    let safePercentage = progress.progressPercentage.isNaN || progress.progressPercentage.isInfinite ? 0 : progress.progressPercentage
                    Text("\(Int(safePercentage))%")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    Spacer()
                    Text("\(progress.daysRemaining) \(localization.main.days)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                GeometryReader { geometry in
                    let safePercentage = progress.progressPercentage.isNaN || progress.progressPercentage.isInfinite ? 0 : progress.progressPercentage
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.progressTrack)
                            .frame(height: 10)
                            .cornerRadius(5)
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.pink, Color.orange, Color.yellow],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * (safePercentage / 100), height: 10)
                            .cornerRadius(5)
                            .shadow(color: .pink.opacity(0.6), radius: 4)
                    }
                }
                .frame(height: 10)
                
                HStack {
                    let safeCurrentAmount = progress.currentAmount.isNaN || progress.currentAmount.isInfinite ? 0 : progress.currentAmount
                    Text("\(Int(safeCurrentAmount)) \(currencySymbol)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    let safeTargetAmount = progress.targetAmount.isNaN || progress.targetAmount.isInfinite ? 0 : progress.targetAmount
                    Text("\(Int(safeTargetAmount)) \(currencySymbol)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct EmptyPiggyBankCard: View {
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "banknote")
                .font(.largeTitle)
                .foregroundColor(.textTertiary)
            Text(localization.main.noActiveGoal)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
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
