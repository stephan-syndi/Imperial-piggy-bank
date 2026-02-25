//
//  DailySavingsChart.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import SwiftUI

struct DailySavingsChart: View {
    let savings: [DailySaving]
    let days: Int
    let currencySymbol: String
    @EnvironmentObject var localization: LocalizationManager
    
    init(savings: [DailySaving], days: Int = 30, currencySymbol: String) {
        self.savings = savings
        self.days = days
        self.currencySymbol = currencySymbol
    }
    
    private var maxAmount: Double {
        savings.map { $0.amount }.max() ?? 1
    }
    
    private var totalAmount: Double {
        savings.reduce(0) { $0 + $1.amount }
    }
    
    private var columnWidth: CGFloat {
        days <= 7 ? 40 : 20
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Заголовок
            HStack {
                Label(localization.piggyBank.savingsBreakdown, systemImage: "chart.bar.fill")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                let safeTotalAmount = totalAmount.isNaN || totalAmount.isInfinite ? 0 : totalAmount
                Text("\(Int(safeTotalAmount)) \(currencySymbol)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.adaptiveGreen)
            }
            
            // График с горизонтальным скроллом для 30 дней
            if days > 7 {
                ScrollView(.horizontal, showsIndicators: true) {
                    chartContent
                        .padding(.horizontal, 4)
                }
                .frame(height: 140)
            } else {
                chartContent
                    .frame(height: 120)
                    .padding(.vertical, 8)
            }
            
            // Легенда
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(localization.piggyBank.averageAmount)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    let activeSavings = savings.filter { $0.amount > 0 }
                    let averageAmount = activeSavings.isEmpty ? 0 : totalAmount / Double(activeSavings.count)
                    Text("\(Int(averageAmount.isNaN || averageAmount.isInfinite ? 0 : averageAmount)) \(currencySymbol)\(localization.piggyBank.perDay)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(localization.piggyBank.maxPerDay)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    Text("\(Int(maxAmount.isNaN || maxAmount.isInfinite ? 0 : maxAmount)) \(currencySymbol)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color.adaptiveGreen.opacity(0.1),
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
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.borderColor, lineWidth: 1.5)
        )
        .shadow(color: Color.adaptiveGreen.opacity(0.15), radius: 12, x: 0, y: 6)
    }
    
    // MARK: - Subviews
    private var chartContent: some View {
        HStack(alignment: .bottom, spacing: days <= 7 ? 8 : 4) {
            ForEach(savings) { saving in
                VStack(spacing: 4) {
                    // Столбец
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: saving.amount > 0
                                    ? [.green, .mint, .cyan]
                                    : [.gray.opacity(0.2), .gray.opacity(0.3)],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(
                            width: columnWidth,
                            height: saving.amount > 0
                                ? max(20, CGFloat(saving.amount / maxAmount) * 100)
                                : 8
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(
                                    saving.amount > 0 ? Color.green.opacity(0.4) : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: saving.amount > 0 ? .green.opacity(0.4) : .clear, radius: 4, x: 0, y: 2)
                    
                    // День недели (показываем только для недельного графика)
                    if days <= 7 {
                        Text(saving.dayOfWeek)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            // 7-дневный график
            DailySavingsChart(
                savings: {
                    let calendar = Calendar.current
                    return (0..<7).map { offset in
                        DailySaving(
                            date: calendar.date(byAdding: .day, value: -offset, to: Date()) ?? Date(),
                            amount: Double.random(in: 500...2500),
                            note: nil
                        )
                    }.reversed()
                }(),
                days: 7,
                currencySymbol: "₽"
            )
            .padding(.horizontal)
            
            // 30-дневный график
            DailySavingsChart(
                savings: {
                    let calendar = Calendar.current
                    return (0..<30).map { offset in
                        DailySaving(
                            date: calendar.date(byAdding: .day, value: -offset, to: Date()) ?? Date(),
                            amount: Int.random(in: 0...10) > 2 ? Double.random(in: 500...2500) : 0,
                            note: nil
                        )
                    }.reversed()
                }(),
                days: 30,
                currencySymbol: "₽"
            )
            .padding(.horizontal)
        }
    }
    .environmentObject(LocalizationManager.shared)
}
