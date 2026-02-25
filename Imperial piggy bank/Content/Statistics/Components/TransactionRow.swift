//
//  TransactionRow.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    let currencySymbol: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    LinearGradient(
                        colors: [
                            transaction.color,
                            transaction.color.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: transaction.color.opacity(0.4), radius: 5, x: 0, y: 3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                HStack(spacing: 4) {
                    Text(transaction.category)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    Text(transaction.date, style: .time)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Spacer()
            
            Text("-\(String(format: "%.0f", transaction.amount)) \(currencySymbol)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.adaptiveRed)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TransactionRow(
        transaction: Transaction(
            title: "Кофе",
            category: "Еда",
            amount: 150,
            date: Date(),
            icon: "cup.and.saucer.fill",
            color: .brown
        ),
        currencySymbol: "₽"
    )
}
