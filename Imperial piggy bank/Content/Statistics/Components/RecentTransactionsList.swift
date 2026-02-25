//
//  RecentTransactionsList.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct RecentTransactionsList: View {
    let transactions: [Transaction]
    let currencySymbol: String
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localization.statistics.recentTransactions)
                .font(.headline)
                .padding(.horizontal)
            
            if transactions.isEmpty {
                Text(localization.statistics.noDataYet)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                VStack(spacing: 8) {
                    ForEach(transactions) { transaction in
                        TransactionRow(transaction: transaction, currencySymbol: currencySymbol)
                    }
                }
            }
        }
        .padding()
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color.adaptiveRed.opacity(0.1),
                        Color.adaptiveOrange.opacity(0.1)
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
        .shadow(color: .red.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

#Preview {
    RecentTransactionsList(transactions: [
        Transaction(
            title: "Кофе",
            category: "Еда",
            amount: 150,
            date: Date(),
            icon: "cup.and.saucer.fill",
            color: .brown
        ),
        Transaction(
            title: "Такси",
            category: "Транспорт",
            amount: 250,
            date: Date().addingTimeInterval(-3600),
            icon: "car.fill",
            color: .blue
        )
    ], currencySymbol: "₽")
    .environmentObject(LocalizationManager.shared)
}
