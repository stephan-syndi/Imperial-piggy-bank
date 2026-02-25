//
//  BudgetEditorSheet.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct BudgetEditorSheet: View {
    @Binding var budget: String
    let period: TimePeriod
    let currencySymbol: String
    let onSave: () -> Void
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localization: LocalizationManager
    
    private var periodLabel: String {
        switch period {
        case .day: return localization.finance.day.lowercased()
        case .week: return localization.finance.week.lowercased()
        case .month: return localization.finance.month.lowercased()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "rublesign.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text(localization.sheets.budgetPlanning)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(localization.sheets.on) \(periodLabel)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(localization.sheets.budgetAmount)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        TextField(localization.sheets.enterAmount, text: $budget)
                            .keyboardType(.decimalPad)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.inputFieldBackground)
                            .cornerRadius(12)
                        
                        Text(currencySymbol)
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: onSave) {
                        Text(localization.sheets.save)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    Button(action: { dismiss() }) {
                        Text(localization.sheets.cancel)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.inputFieldBackground)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    BudgetEditorSheet(budget: .constant("5000"), period: .day, currencySymbol: "₽", onSave: {})
}
