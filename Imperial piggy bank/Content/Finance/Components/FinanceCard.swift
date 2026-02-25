//
//  FinanceCard.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct FinanceCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        color.opacity(0.15),
                        color.opacity(0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Стеклянный эффект
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
        .shadow(color: color.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    FinanceCard(
        title: "Потрачено",
        value: "1250 ₽",
        icon: "arrow.down.circle.fill",
        color: .red
    )
}
