//
//  RecentSavingsList.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import SwiftUI

struct RecentSavingsList: View {
    let savings: [DailySaving]
    let limit: Int
    let currencySymbol: String
    @EnvironmentObject var localization: LocalizationManager
    
    init(savings: [DailySaving], limit: Int = 10, currencySymbol: String) {
        self.savings = savings
        self.limit = limit
        self.currencySymbol = currencySymbol
    }
    
    private var recentSavings: [DailySaving] {
        Array(savings.sorted { $0.date > $1.date }.prefix(limit))
    }
    
    private var noSavingsText: String {
        localization.piggyBank.noSavingsYet
    }
    
    private var autoSavingsText: String {
        localization.piggyBank.autoSavingsDescription
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(localization.piggyBank.recentSavings, systemImage: "clock.fill")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            if recentSavings.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 40))
                        .foregroundColor(.textSecondary)
                    
                    Text(noSavingsText)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text(autoSavingsText)
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(recentSavings.enumerated()), id: \.element.id) { index, saving in
                        SavingRow(saving: saving, currencySymbol: currencySymbol)
                        
                        if index < recentSavings.count - 1 {
                            Divider()
                                .padding(.leading, 56)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color.adaptiveGreen.opacity(0.1),
                        Color.mint.opacity(0.1)
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
        .shadow(color: Color.adaptiveGreen.opacity(0.15), radius: 12, x: 0, y: 6)
    }
}

struct SavingRow: View {
    let saving: DailySaving
    let currencySymbol: String
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        HStack(spacing: 12) {
            // Иконка
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.green, .mint, .cyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 2)
                )
                .shadow(color: .green.opacity(0.4), radius: 6, x: 0, y: 3)
            
            VStack(alignment: .leading, spacing: 4) {
                if let note = saving.note {
                    Text(note)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                } else {
                    Text(localization.piggyBank.budgetRemainder)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Text(saving.formattedDate)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            let safeAmount = saving.amount.isNaN || saving.amount.isInfinite ? 0 : saving.amount
            Text("+\(Int(safeAmount)) \(currencySymbol)")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.adaptiveGreen)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            // Пустой список
            RecentSavingsList(savings: [], limit: 5, currencySymbol: "₽")
                .padding(.horizontal)
            
            // Заполненный список
            RecentSavingsList(
                savings: {
                    let calendar = Calendar.current
                    return (0..<10).map { offset in
                        DailySaving(
                            date: calendar.date(byAdding: .day, value: -offset, to: Date()) ?? Date(),
                            amount: Double.random(in: 500...3000),
                            note: offset % 3 == 0 ? "Зарплата" : (offset % 2 == 0 ? "Подработка" : nil)
                        )
                    }
                }(),
                limit: 5,
                currencySymbol: "₽"
            )
            .padding(.horizontal)
        }
    }
    .environmentObject(LocalizationManager.shared)
}
