//
//  StatisticsView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 5.02.26.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var viewModel: StatisticsViewModel
    @State private var showingSavingsGoalEditor = false
    @EnvironmentObject var localization: LocalizationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Копилка
                    SavingsProgressView(
                        savingsGoal: viewModel.savingsGoal,
                        currencySymbol: viewModel.currencySymbol,
                        onEdit: {
                            showingSavingsGoalEditor = true
                        }
                    )
                    .padding(.horizontal)
                    
                    // Графики
                    VStack(spacing: 16) {
                        // График трат за неделю
                        WeeklyExpenseChart(weeklyExpenses: viewModel.weeklyExpenses)
                        
                        // График по категориям
//                        CategoryExpenseChart(categoryExpenses: viewModel.categoryExpenses)
                    }
                    .padding(.horizontal)
                    
                    // Детализация по категориям
                    CategoryDetailList(
                        categoryExpenses: viewModel.categoryExpenses,
                        total: viewModel.spent,
                        currencySymbol: viewModel.currencySymbol
                    )
                    
                    // Последние траты
                    RecentTransactionsList(
                        transactions: viewModel.recentTransactions,
                        currencySymbol: viewModel.currencySymbol
                    )
                    
                }
                .padding(.vertical)
            }
            .themedBackground(
                .statistics,
                appearanceMode: viewModel.userSettings.appearanceMode,
                colorScheme: colorScheme
            )
            .navigationTitle(localization.statistics.title)
            .sheet(isPresented: $showingSavingsGoalEditor) {
                SavingsGoalEditorSheet(
                    existingGoal: viewModel.savingsGoal,
                    currencySymbol: viewModel.currencySymbol,
                    onSave: { goal in
                        viewModel.updateSavingsGoal(goal)
                    }
                )
            }
        }
    }
}

#Preview {
    let finance = UserFinanceModel()
    let settings = UserSettingsModel()
    let piggyBankVM = PiggyBankViewModel(userSettings: settings)
    return StatisticsView(viewModel: StatisticsViewModel(userFinance: finance, userSettings: settings, piggyBankViewModel: piggyBankVM))
}
