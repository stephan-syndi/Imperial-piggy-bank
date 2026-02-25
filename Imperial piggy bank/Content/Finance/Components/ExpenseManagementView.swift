//
//  ExpenseManagementView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct ExpenseManagementView: View {
    let onAddExpense: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Управление тратами")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            Button(action: onAddExpense) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    Text("Добавить трату")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.cyan]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ExpenseManagementView(onAddExpense: {})
}
