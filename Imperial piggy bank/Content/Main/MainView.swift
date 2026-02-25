//
//  MainView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 5.02.26.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    var onFinanceTap: (() -> Void)? = nil
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. Дата и календарь
                    DateHeaderView(currentDate: viewModel.currentDate)
                    
                    // 2. Приветствие
                    WelcomeCardView(userName: viewModel.userName)
                    
                    // 3. Прогресс копилки
                    DayStatsView(
                        savingsProgress: viewModel.savingsProgress,
                        currencySymbol: viewModel.currencySymbol
                    )
                    
                    // 4. Цель по бюджету
                    BudgetCardView(
                        budgetInfo: viewModel.budgetInfo,
                        currencySymbol: viewModel.currencySymbol
                    ) {
                        onFinanceTap?()
                    }
                    
                    // 5. Активности (траты) дня
                    ExpenseListView(
                        expenses: viewModel.expenses,
                        currencySymbol: viewModel.currencySymbol
                    )
                    
                }
                .padding()
            }
            .themedBackground(
                .main,
                appearanceMode: viewModel.userSettings.appearanceMode,
                colorScheme: colorScheme
            )
            .navigationBarHidden(true)
            .onAppear {
                viewModel.checkAndShowDailySummary()
            }
            .overlay(
                FloatingAddButton {
                    viewModel.showExpenseAdder = true
                }
            )
            .sheet(isPresented: $viewModel.showExpenseAdder) {
                QuickExpenseAdderSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showDailySummary) {
                if let summary = viewModel.dailySummaryToShow {
                    DailySummarySheet(
                        summaryData: summary,
                        currencySymbol: viewModel.currencySymbol,
                        onClose: {
                            viewModel.markSummaryAsViewed()
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    let finance = UserFinanceModel()
    let settings = UserSettingsModel()
    let piggyBank = PiggyBankViewModel(userSettings: settings)
    finance.setBudget(5000, for: .day)
    return MainView(viewModel: MainViewModel(userFinance: finance, userSettings: settings, piggyBankViewModel: piggyBank))
}
