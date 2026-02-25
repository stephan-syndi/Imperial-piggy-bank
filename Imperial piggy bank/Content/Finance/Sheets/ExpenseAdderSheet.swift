//
//  ExpenseAdderSheet.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct ExpenseAdderSheet: View {
    @Binding var title: String
    @Binding var amount: String
    @Binding var category: String
    let categories: [String]
    let currencySymbol: String
    let onSave: () -> Void
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "cart.fill.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                    
                    Text(localization.sheets.newExpense)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localization.sheets.name)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField(localization.sheets.expensePlaceholder, text: $title)
                            .padding()
                            .background(Color.inputFieldBackground)
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localization.sheets.amount)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            TextField("0", text: $amount)
                                .keyboardType(.decimalPad)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding()
                                .background(Color.inputFieldBackground)
                                .cornerRadius(12)
                            
                            Text(currencySymbol)
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localization.sheets.category)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Menu {
                            ForEach(categories, id: \.self) { cat in
                                Button(cat) {
                                    category = cat
                                }
                            }
                        } label: {
                            HStack {
                                Text(category)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.inputFieldBackground)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: onSave) {
                        Text(localization.main.addExpense)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(title.isEmpty || amount.isEmpty ? Color.gray : Color.red)
                            .cornerRadius(12)
                    }
                    .disabled(title.isEmpty || amount.isEmpty)
                    
                    Button(action: { dismiss() }) {
                        Text(localization.sheets.cancel)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
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
    ExpenseAdderSheet(
        title: .constant(""),
        amount: .constant(""),
        category: .constant("Еда"),
        categories: ["Еда", "Транспорт", "Развлечения", "Покупки", "Прочее"],
        currencySymbol: "₽",
        onSave: {}
    )
}
