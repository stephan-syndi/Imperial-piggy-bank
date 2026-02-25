//
//  BudgetProgressView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct BudgetProgressView: View {
    let spentPercentage: Double
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(localization.finance.spent)
                    .font(.headline)
                Spacer()
                Text("\(Int(spentPercentage * 100))%")
                    .font(.headline)
                    .foregroundColor(spentPercentage > 0.8 ? .adaptiveRed : .adaptiveBlue)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.progressTrack)
                        .frame(height: 24)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: spentPercentage > 0.8 ? 
                                    [Color.adaptiveRed, Color.adaptiveOrange, Color.adaptiveYellow] : 
                                    [Color.adaptiveBlue, Color.cyan, Color.adaptiveGreen]
                                ),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * spentPercentage, height: 24)
                        .shadow(color: (spentPercentage > 0.8 ? Color.adaptiveRed : Color.adaptiveBlue).opacity(0.5), radius: 5)
                }
            }
            .frame(height: 24)
        }
        .padding()
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color.adaptiveBlue.opacity(0.1),
                        Color.cyan.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                    .blur(radius: 0.5)
            }
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderColor, lineWidth: 1.5)
        )
        .shadow(color: Color.adaptiveBlue.opacity(0.15), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

#Preview {
    BudgetProgressView(spentPercentage: 0.65)
}
