//
//  QuickExpenseAdderSheet.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct QuickExpenseAdderSheet: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        NavigationView {
            ZStack {
                // Адаптивный фон для темной/светлой темы
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "cart.fill.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                    
                    Text(localization.sheets.quickExpense)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(localization.sheets.addExpenseForDay)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localization.sheets.name)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField(localization.sheets.expensePlaceholder, text: $viewModel.newExpenseTitle)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.inputFieldBackground)
                                    .shadow(color: .black.opacity(0.05), radius: 5)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localization.sheets.amount)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            TextField("0", text: $viewModel.newExpenseAmount)
                                .keyboardType(.decimalPad)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.inputFieldBackground)
                                        .shadow(color: .black.opacity(0.05), radius: 5)
                                )
                            
                            Text(viewModel.currencySymbol)
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localization.sheets.category)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Menu {
                            ForEach(viewModel.categories, id: \.self) { cat in
                                Button(cat) {
                                    viewModel.newExpenseCategory = cat
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.newExpenseCategory)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: {
                        viewModel.addExpense()
                    }) {
                        Text(localization.sheets.add)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: viewModel.newExpenseTitle.isEmpty || viewModel.newExpenseAmount.isEmpty ? 
                                        [Color.gray, Color.gray.opacity(0.8)] : 
                                        [Color.red, Color.orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: viewModel.newExpenseTitle.isEmpty || viewModel.newExpenseAmount.isEmpty ? .clear : .red.opacity(0.4), radius: 8)
                    }
                    .disabled(viewModel.newExpenseTitle.isEmpty || viewModel.newExpenseAmount.isEmpty)
                    
                    Button(action: { dismiss() }) {
                        Text(localization.sheets.cancel)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.inputFieldBackground)
                                    .shadow(color: .black.opacity(0.05), radius: 5)
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
