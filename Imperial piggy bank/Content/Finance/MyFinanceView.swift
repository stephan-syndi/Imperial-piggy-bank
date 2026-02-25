//
//  MyFinanceView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 5.02.26.
//

import SwiftUI
import Charts
import Foundation

struct MyFinanceView: View {
    @ObservedObject var viewModel: MyFinanceViewModel
    @EnvironmentObject var localization: LocalizationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                    
                    // 1. Toolbar с выбором периода
                    Picker(localization.finance.period, selection: $viewModel.selectedPeriod) {
                        ForEach(TimePeriod.allCases, id: \.self) { period in
                            Text(periodLabel(period)).tag(period)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // 2. Горизонтальный контейнер с данными
                    HStack(spacing: 12) {
                        FinanceCard(
                            title: localization.finance.spent,
                            value: String(format: "%.0f \(viewModel.currencySymbol)", viewModel.spent),
                            icon: "arrow.down.circle.fill",
                            color: .red
                        )
                        
                        FinanceCard(
                            title: localization.finance.remaining,
                            value: String(format: "%.0f \(viewModel.currencySymbol)", viewModel.remaining),
                            icon: "wallet.pass.fill",
                            color: .green
                        )
                        
                        FinanceCard(
                            title: localization.finance.budget,
                            value: String(format: "%.0f \(viewModel.currencySymbol)", viewModel.budget),
                            icon: "banknote.fill",
                            color: .blue
                        )
                    }
                    .padding(.horizontal)
                    
                    // 3. Прогресс-бар бюджета
                    BudgetProgressView(spentPercentage: viewModel.spentPercentage)
                    
                    // 4. Планирование бюджета
                    BudgetPlanningView(
                        budget: viewModel.budget,
                        periodLabel: viewModel.periodLabel,
                        currencySymbol: viewModel.currencySymbol,
                        onEdit: viewModel.openBudgetEditor
                    )
                    
                    // 5. Планирование трат
                    ExpensePlanningView(
                        selectedPeriod: viewModel.selectedPeriod,
                        plannedExpenses: viewModel.plannedExpenses,
                        currencySymbol: viewModel.currencySymbol,
                        onOpenPlanner: { viewModel.showExpensePlanner = true }
                    )
                    
                    // 6. Список совершенных трат
                    if !viewModel.expenses.isEmpty {
                        ExpenseListView(
                            expenses: viewModel.expenses,
                            currencySymbol: viewModel.currencySymbol
                        )
                        .padding(.horizontal)
                    }
                    
                }
                .padding(.vertical)
            }
            .themedBackground(
                .finance,
                appearanceMode: viewModel.userSettings.appearanceMode,
                colorScheme: colorScheme
            )
            
            // Плавающая кнопка добавления траты
            FloatingAddButton {
                viewModel.showExpenseAdder = true
            }
        }
        .navigationTitle(localization.finance.myFinance)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                PiggyBankButton(
                    progressPercentage: viewModel.piggyBankProgress,
                    viewModel: viewModel.piggyBankViewModel
                )
            }
        }
        .sheet(isPresented: $viewModel.showBudgetEditor) {
                BudgetEditorSheet(
                    budget: $viewModel.newBudget,
                    period: viewModel.selectedPeriod,
                    currencySymbol: viewModel.currencySymbol,
                    onSave: viewModel.saveBudget
                )
            }
            .sheet(isPresented: $viewModel.showExpenseAdder) {
                ExpenseAdderSheet(
                    title: $viewModel.newExpenseTitle,
                    amount: $viewModel.newExpenseAmount,
                    category: $viewModel.newExpenseCategory,
                    categories: viewModel.categories,
                    currencySymbol: viewModel.currencySymbol,
                    onSave: viewModel.addExpense
                )
            }
            .sheet(isPresented: $viewModel.showExpensePlanner) {
                ExpensePlannerSheet(
                    plannedExpenses: viewModel.plannedExpensesBinding,
                    period: viewModel.selectedPeriod,
                    categories: viewModel.categories,
                    currencySymbol: viewModel.currencySymbol
                )
            }
        }
    }
    
    private func periodLabel(_ period: TimePeriod) -> String {
        switch period {
        case .day: return localization.finance.day
        case .week: return localization.finance.week
        case .month: return localization.finance.month
        }
    }
}

#Preview {
    let finance = UserFinanceModel()
    let settings = UserSettingsModel()
    let piggyBankVM = PiggyBankViewModel(userSettings: settings)
    finance.setBudget(5000, for: .day)
    return MyFinanceView(viewModel: MyFinanceViewModel(userFinance: finance, userSettings: settings, piggyBankViewModel: piggyBankVM))
}
