//
//  DailySummarySheet.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 25.02.26.
//

import SwiftUI

struct DailySummarySheet: View {
    let summaryData: DailySummaryData
    let currencySymbol: String
    let onClose: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        NavigationView {
            ZStack {
                // Адаптивный фон для темной/светлой темы
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Заголовок с иконкой
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(summaryData.saved > 0 ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: summaryData.saved > 0 ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(summaryData.saved > 0 ? .green : .orange)
                            }
                            
                            Text(localization.sheets.dailySummary)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(formattedDate)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        
                        // Карточки с данными
                        VStack(spacing: 16) {
                            // Бюджет
                            SummaryCard(
                                icon: "rublesign.circle.fill",
                                title: localization.sheets.dailyBudget,
                                value: summaryData.budget,
                                currencySymbol: currencySymbol,
                                color: .blue
                            )
                            
                            // Потрачено
                            SummaryCard(
                                icon: "cart.fill",
                                title: localization.sheets.spent,
                                value: summaryData.spent,
                                currencySymbol: currencySymbol,
                                color: .red
                            )
                            
                            // Сэкономлено
                            SummaryCard(
                                icon: "banknote.fill",
                                title: localization.sheets.saved,
                                value: summaryData.saved,
                                currencySymbol: currencySymbol,
                                color: .green
                            )
                        }
                        .padding(.horizontal)
                        
                        // Процент использования бюджета
                        if summaryData.budget > 0 {
                            VStack(spacing: 12) {
                                HStack {
                                    Text(localization.sheets.budgetUsage)
                                        .font(.headline)
                                    Spacer()
                                    Text("\(Int(spentPercentage * 100))%")
                                        .font(.headline)
                                        .foregroundColor(spentPercentage > 1.0 ? .red : .primary)
                                }
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 16)
                                        
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(progressColor)
                                            .frame(width: min(geometry.size.width * CGFloat(spentPercentage), geometry.size.width), height: 16)
                                    }
                                }
                                .frame(height: 16)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.05), radius: 10)
                            )
                            .padding(.horizontal)
                        }
                        
                        // Кнопка закрытия
                        Button(action: {
                            onClose()
                            dismiss()
                        }) {
                            Text(localization.sheets.great)
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.blue)
                                )
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        onClose()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: summaryData.date)
    }
    
    private var spentPercentage: Double {
        guard summaryData.budget > 0 else { return 0 }
        return summaryData.spent / summaryData.budget
    }
    
    private var progressColor: Color {
        if spentPercentage <= 0.7 {
            return .green
        } else if spentPercentage <= 1.0 {
            return .orange
        } else {
            return .red
        }
    }
}

// MARK: - Summary Card Component
struct SummaryCard: View {
    let icon: String
    let title: String
    let value: Double
    let currencySymbol: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(String(format: "%.2f", value)) \(currencySymbol)")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10)
        )
    }
}

#Preview {
    let summaryData = DailySummaryData(
        date: Date(),
        budget: 5000,
        spent: 3500
    )
    return DailySummarySheet(
        summaryData: summaryData,
        currencySymbol: "₽",
        onClose: {}
    )
    .environmentObject(LocalizationManager.shared)
}
