//
//  CategoryDetailRow.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct CategoryDetailRow: View {
    let category: CategoryExpense
    let total: Double
    let currencySymbol: String
    
    var percentage: Double {
        guard total > 0 else { return 0 }
        return (category.amount / total) * 100
    }
    
    var progressRatio: Double {
        guard total > 0 else { return 0 }
        return category.amount / total
    }
    
    var body: some View {
        HStack(spacing: 12) {
                Image(systemName: category.icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    LinearGradient(
                        colors: [
                            category.color,
                            category.color.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: category.color.opacity(0.4), radius: 5, x: 0, y: 3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.progressTrack)
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        category.color,
                                        category.color.opacity(0.7)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progressRatio, height: 8)
                            .shadow(color: category.color.opacity(0.4), radius: 3)
                    }
                }
                .frame(height: 8)
            }
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.0f \(currencySymbol)", category.amount))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(String(format: "%.1f%%", percentage))
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CategoryDetailRow(
        category: CategoryExpense(name: "Еда", amount: 450, color: .orange, icon: "fork.knife"),
        total: 1250,
        currencySymbol: "₽"
    )
}
