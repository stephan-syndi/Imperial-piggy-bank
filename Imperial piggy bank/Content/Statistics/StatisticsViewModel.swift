//
//  StatisticsViewModel.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import Foundation
import SwiftUI
import Combine

class StatisticsViewModel: ObservableObject {
    // MARK: - Models
    @ObservedObject var userFinance: UserFinanceModel
    @ObservedObject var userSettings: UserSettingsModel
    @ObservedObject var piggyBankViewModel: PiggyBankViewModel
    
    // MARK: - Published Properties
    @Published var spent: Double = 0
    
    private var cancellables = Set<AnyCancellable>()
    @Published var weeklyExpenses: [DailyExpense] = []
    @Published var categoryExpenses: [CategoryExpense] = []
    @Published var recentTransactions: [Transaction] = []
    
    // MARK: - Computed Properties
    var currencySymbol: String {
        userSettings.currency.symbol
    }
    
    var savingsGoal: SavingsGoal? {
        piggyBankViewModel.savingsGoal
    }
    
    // MARK: - Initialization
    init(userFinance: UserFinanceModel, userSettings: UserSettingsModel, piggyBankViewModel: PiggyBankViewModel) {
        self.userFinance = userFinance
        self.userSettings = userSettings
        self.piggyBankViewModel = piggyBankViewModel
        
        // Загружаем начальные данные
        loadStatisticsData()
        
        // Подписка на изменения финансов
        userFinance.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
            self?.loadStatisticsData()
        }.store(in: &cancellables)
        
        // Подписка на изменения настроек
        userSettings.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
        // Подписка на изменения копилки
        piggyBankViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }
    
    // MARK: - Computed Properties
    var totalCategoryExpenses: Double {
        categoryExpenses.reduce(0) { $0 + $1.amount }
    }
    
    // MARK: - Methods
    func categoryPercentage(for category: CategoryExpense) -> Double {
        guard spent > 0 else { return 0 }
        return (category.amount / spent) * 100
    }
    
    func categoryProgressRatio(for category: CategoryExpense) -> Double {
        guard spent > 0 else { return 0 }
        return category.amount / spent
    }
    
    // MARK: - Data Loading Methods
    
    /// Загружает данные статистики из UserFinanceModel
    func loadStatisticsData() {
        // Загружаем траты за текущий день и последние 7 дней
        loadWeeklyExpenses()
        
        // Загружаем траты по категориям
        loadCategoryExpenses()
        
        // Загружаем последние транзакции
        loadRecentTransactions()
        
        // Обновляем общую сумму трат за неделю
        spent = weeklyExpenses.reduce(0) { $0 + $1.amount }
    }
    
    /// Загружает траты за последние 7 дней
    private func loadWeeklyExpenses() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var allExpenses: [DailyExpense] = []
        
        // Добавляем сегодняшние траты
        allExpenses.append(contentsOf: userFinance.todayExpenses)
        
        // Добавляем траты за последние 6 дней из истории
        for daysAgo in 1...6 {
            if let date = calendar.date(byAdding: .day, value: -daysAgo, to: today),
               let expenses = userFinance.expenseHistory[date] {
                allExpenses.append(contentsOf: expenses)
            }
        }
        
        weeklyExpenses = allExpenses.sorted { $0.date > $1.date }
    }
    
    /// Загружает траты по категориям
    private func loadCategoryExpenses() {
        var categoryDict: [String: Double] = [:]
        
        // Собираем все траты за последние 7 дней
        for expense in weeklyExpenses {
            categoryDict[expense.category, default: 0] += expense.amount
        }
        
        // Преобразуем в массив CategoryExpense с цветами и иконками
        let localization = LocalizationManager.shared
        categoryExpenses = categoryDict.map { category, amount in
            CategoryExpense(
                name: category,
                amount: amount,
                color: colorForCategory(category),
                icon: iconForCategory(category)
            )
        }.sorted { $0.amount > $1.amount }
    }
    
    /// Загружает последние транзакции
    private func loadRecentTransactions() {
        recentTransactions = weeklyExpenses.prefix(10).map { expense in
            Transaction(
                title: expense.title,
                category: expense.category,
                amount: expense.amount,
                date: expense.date,
                icon: iconForCategory(expense.category),
                color: colorForCategory(expense.category)
            )
        }
    }
    
    // MARK: - Helper Methods
    
    private func colorForCategory(_ category: String) -> Color {
        let localization = LocalizationManager.shared
        switch category {
        case localization.categories.food:
            return .green
        case localization.categories.transport:
            return .blue
        case localization.categories.entertainment:
            return .purple
        case localization.categories.shopping:
            return .orange
        default:
            return .gray
        }
    }
    
    private func iconForCategory(_ category: String) -> String {
        let localization = LocalizationManager.shared
        switch category {
        case localization.categories.food:
            return "cart.fill"
        case localization.categories.transport:
            return "bus.fill"
        case localization.categories.entertainment:
            return "gamecontroller.fill"
        case localization.categories.shopping:
            return "bag.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
    
    // MARK: - Savings Methods
    func updateSavingsGoal(_ goal: SavingsGoal) {
        piggyBankViewModel.updateSavingsGoal(goal)
    }
}
