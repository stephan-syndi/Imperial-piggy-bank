//
//  CategoryDetailList.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct CategoryDetailList: View {
    let categoryExpenses: [CategoryExpense]
    let total: Double
    let currencySymbol: String
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localization.statistics.categoryDetails)
                .font(.headline)
                .padding(.horizontal)
            
            if categoryExpenses.isEmpty {
                Text(localization.statistics.noDataYet)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                VStack(spacing: 8) {
                    ForEach(categoryExpenses) { category in
                        CategoryDetailRow(category: category, total: total, currencySymbol: currencySymbol)
                    }
                }
            }
        }
        .padding()
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color.adaptivePurple.opacity(0.1),
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
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
            .stroke(Color.borderColor, lineWidth: 1.5))
            .shadow(color: .purple.opacity(0.2), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
    }
}

#Preview {
    CategoryDetailList(
        categoryExpenses: [
            CategoryExpense(name: "Еда", amount: 450, color: .orange, icon: "fork.knife"),
            CategoryExpense(name: "Транспорт", amount: 200, color: .blue, icon: "car.fill")
        ],
        total: 1250,
        currencySymbol: "₽"
    )
    .environmentObject(LocalizationManager.shared)
}
