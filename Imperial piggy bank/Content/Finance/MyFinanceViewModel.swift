//
//  MyFinanceViewModel.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import Foundation
import Combine
import SwiftUI

class MyFinanceViewModel: ObservableObject {
    // MARK: - User Finance Model
    @ObservedObject var userFinance: UserFinanceModel
    // MARK: - User Settings Model
    @ObservedObject var userSettings: UserSettingsModel
    // MARK: - Piggy Bank View Model
    @ObservedObject var piggyBankViewModel: PiggyBankViewModel
    
    // MARK: - Published Properties
    @Published var selectedPeriod: TimePeriod = .day
    
    private var cancellables = Set<AnyCancellable>()
    
    // Piggy Bank Progress
    var piggyBankProgress: Double {
        guard let goal = piggyBankViewModel.savingsGoal else { return 0 }
        return goal.progressPercentage
    }
    
    // MARK: - Sheet States
    @Published var showBudgetEditor: Bool = false
    @Published var showExpenseAdder: Bool = false
    @Published var showExpensePlanner: Bool = false
    
    // MARK: - Form States
    @Published var newBudget: String = ""
    @Published var newExpenseTitle: String = ""
    @Published var newExpenseAmount: String = ""
    @Published var newExpenseCategory: String
    
    // MARK: - Computed Properties for Categories
    var categories: [String] {
        LocalizationManager.shared.allCategories
    }
    
    // MARK: - Computed Properties (используют userFinance)
    
    var budget: Double {
        userFinance.getBudget(for: selectedPeriod).amount
    }
    
    var spent: Double {
        // Для дня - текущие траты, для недели/месяца - можно расширить логику
        switch selectedPeriod {
        case .day:
            return userFinance.todaySpent
        case .week, .month:
            // TODO: Добавить логику для недельных/месячных трат
            return userFinance.todaySpent
        }
    }
    
    var remaining: Double {
        budget - spent
    }
    
    var spentPercentage: Double {
        guard budget > 0 else { return 0 }
        return min(spent / budget, 1.0)
    }
    
    var periodLabel: String {
        selectedPeriod.label
    }
    
    var plannedExpenses: [PlannedExpense] {
        userFinance.getPlannedExpenses(for: selectedPeriod)
    }
    
    var totalPlanned: Double {
        userFinance.totalPlannedAmount(for: selectedPeriod)
    }
    
    var expenses: [DailyExpense] {
        userFinance.todayExpenses
    }
    
    var currencySymbol: String {
        userSettings.currency.symbol
    }
    
    // Binding для работы с планируемыми тратами текущего периода
    var plannedExpensesBinding: Binding<[PlannedExpense]> {
        Binding(
            get: {
                self.userFinance.getPlannedExpenses(for: self.selectedPeriod)
            },
            set: { newValue in
                switch self.selectedPeriod {
                case .day:
                    self.userFinance.dailyPlannedExpenses.expenses = newValue
                case .week:
                    self.userFinance.weeklyPlannedExpenses.expenses = newValue
                case .month:
                    self.userFinance.monthlyPlannedExpenses.expenses = newValue
                }
                self.objectWillChange.send()
            }
        )
    }
    
    // MARK: - Initialization
    
    init(userFinance: UserFinanceModel, userSettings: UserSettingsModel, piggyBankViewModel: PiggyBankViewModel) {
        self.userFinance = userFinance
        self.userSettings = userSettings
        self.piggyBankViewModel = piggyBankViewModel
        // Устанавливаем первую категорию из локализованного списка
        self.newExpenseCategory = LocalizationManager.shared.categories.food
        
        // Подписка на изменения моделей
        userFinance.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
        userSettings.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
        piggyBankViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }
    
    // MARK: - Methods
    func saveBudget() {
        if let value = Double(newBudget) {
            userFinance.setBudget(value, for: selectedPeriod)
            objectWillChange.send() // Оповещаем об изменении
            showBudgetEditor = false
        }
    }
    
    func addExpense() {
        guard let value = Double(newExpenseAmount), !newExpenseTitle.isEmpty else {
            return
        }
        
        userFinance.addExpense(title: newExpenseTitle, amount: value, category: newExpenseCategory)
        objectWillChange.send() // Оповещаем об изменении
        resetExpenseForm()
        showExpenseAdder = false
    }
    
    func addPlannedExpense(title: String, amount: Double, category: String, date: Date?) {
        let expense = PlannedExpense(
            title: title,
            amount: amount,
            category: category,
            date: date
        )
        userFinance.addPlannedExpense(expense, for: selectedPeriod)
        objectWillChange.send() // Оповещаем об изменении
    }
    
    func deletePlannedExpense(_ expense: PlannedExpense) {
        userFinance.removePlannedExpense(expense, from: selectedPeriod)
        objectWillChange.send() // Оповещаем об изменении
    }
    
    func openBudgetEditor() {
        newBudget = String(format: "%.0f", budget)
        showBudgetEditor = true
    }
    
    // MARK: - Private Methods
    private func resetExpenseForm() {
        newExpenseTitle = ""
        newExpenseAmount = ""
        newExpenseCategory = LocalizationManager.shared.categories.food
    }
}
