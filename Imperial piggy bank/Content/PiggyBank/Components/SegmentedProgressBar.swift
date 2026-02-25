//
//  SegmentedProgressBar.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import SwiftUI

struct SegmentedProgressBar: View {
    let currentAmount: Double
    let targetAmount: Double
    let segments: Int
    let currencySymbol: String
    @EnvironmentObject var localization: LocalizationManager
    
    init(currentAmount: Double, targetAmount: Double, segments: Int = 10, currencySymbol: String) {
        self.currentAmount = currentAmount
        self.targetAmount = targetAmount
        self.segments = segments
        self.currencySymbol = currencySymbol
    }
    
    private var progressPercentage: Double {
        guard targetAmount > 0 else { return 0 }
        return min((currentAmount / targetAmount) * 100, 100)
    }
    
    private var segmentAmount: Double {
        targetAmount / Double(segments)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Заголовок и цифры
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(localization.piggyBank.savingsProgress)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.textSecondary)
                    
                    let safeCurrentAmount = currentAmount.isNaN || currentAmount.isInfinite ? 0 : currentAmount
                    let safeTargetAmount = targetAmount.isNaN || targetAmount.isInfinite ? 0 : targetAmount
                    Text("\(Int(safeCurrentAmount)) \(currencySymbol) \(localization.piggyBank.of) \(Int(safeTargetAmount)) \(currencySymbol)")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                let safeProgress = progressPercentage.isNaN || progressPercentage.isInfinite ? 0 : progressPercentage
                Text("\(Int(safeProgress))%")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.adaptiveGreen)
            }
            
            // Сегментированная линия прогресса
            HStack(spacing: 2) {
                ForEach(0..<segments, id: \.self) { index in
                    let segmentStart = Double(index) * segmentAmount
                    let segmentEnd = Double(index + 1) * segmentAmount
                    let fillPercentage = calculateSegmentFill(
                        segmentStart: segmentStart,
                        segmentEnd: segmentEnd
                    )
                    
                    GeometryReader { segmentGeometry in
                        ZStack(alignment: .leading) {
                            // Фон сегмента
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.progressTrack)
                            
                            // Заполнение сегмента
                            if fillPercentage > 0 {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(
                                        LinearGradient(
                                            colors: [.green, .mint, .cyan],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: segmentGeometry.size.width * fillPercentage)
                                    .shadow(color: .green.opacity(0.5), radius: 4, x: 0, y: 2)
                                    .overlay(
                                        // Галочка для заполненных или банк для последнего
                                        Group {
                                            if fillPercentage >= 1.0 {
                                                if index == segments - 1 {
                                                    // Иконка банка на последнем сегменте
                                                    Image(systemName: "banknote.fill")
                                                        .font(.system(size: 12, weight: .bold))
                                                        .foregroundColor(.white.opacity(0.8))
                                                } else {
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 10, weight: .bold))
                                                        .foregroundColor(.white.opacity(0.7))
                                                }
                                            }
                                        }
                                    )
                            }
                            
                            // Иконка банка на последнем сегменте (если еще не заполнен)
                            if index == segments - 1 && fillPercentage < 1.0 {
                                Image(systemName: "piggybank.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textTertiary)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(
                                    fillPercentage > 0 ? Color.green.opacity(0.3) : Color.clear,
                                    lineWidth: 1
                                )
                        )
                    }
                }
            }
            .frame(height: 32)
            
            // Метки сегментов - показываем каждые 25%
            HStack(alignment: .top, spacing: 0) {
                ForEach(0...4, id: \.self) { index in
                    VStack(spacing: 2) {
                        // Индикатор
                        Circle()
                            .fill(currentAmount >= (targetAmount * Double(index) / 4) ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 6, height: 6)
                        
                        // Сумма
                        Text("\(formatAmount(targetAmount * Double(index) / 4)) \(currencySymbol)")
                            .font(.system(size: 9))
                            .foregroundColor(.textSecondary)
                    }
                    
                    if index < 4 {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, -2)
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatAmount(_ amount: Double) -> String {
        if amount >= 1000 {
            return String(format: "%.0fk", amount / 1000)
        } else {
            return String(format: "%.0f", amount)
        }
    }
    
    private func calculateSegmentFill(segmentStart: Double, segmentEnd: Double) -> Double {
        if currentAmount >= segmentEnd {
            return 1.0 // Полностью заполнен
        } else if currentAmount <= segmentStart {
            return 0.0 // Пустой
        } else {
            // Частично заполнен
            return (currentAmount - segmentStart) / (segmentEnd - segmentStart)
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        // 45% прогресс
        SegmentedProgressBar(
            currentAmount: 45000,
            targetAmount: 100000,
            segments: 10,
            currencySymbol: "₽"
        )
        .padding()
        
        // 15% прогресс
        SegmentedProgressBar(
            currentAmount: 15000,
            targetAmount: 100000,
            segments: 10,
            currencySymbol: "₽"
        )
        .padding()
        
        // 90% прогресс
        SegmentedProgressBar(
            currentAmount: 100000,
            targetAmount: 100000,
            segments: 10,
            currencySymbol: "₽"
        )
        .padding()
    }
    .environmentObject(LocalizationManager.shared)
}
