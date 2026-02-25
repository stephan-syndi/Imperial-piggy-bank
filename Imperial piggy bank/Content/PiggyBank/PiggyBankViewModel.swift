//
//  PiggyBankViewModel.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import Foundation
import SwiftUI
import Combine

class PiggyBankViewModel: ObservableObject {
    // MARK: - Models
    @ObservedObject var userSettings: UserSettingsModel
    
    // MARK: - Published Properties
    @Published var savingsGoal: SavingsGoal?
    @Published var dailySavings: [DailySaving] = []
    @Published var completedGoals: [CompletedGoal] = []
    @Published var showingSavingsGoalEditor = false
    @Published var showingWithdrawConfirmation = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var currencySymbol: String {
        userSettings.currency.symbol
    }
    
    var isGoalCompleted: Bool {
        guard let goal = savingsGoal else { return false }
        return goal.currentAmount >= goal.targetAmount
    }
    
    var totalSaved: Double {
        dailySavings.reduce(0) { $0 + $1.amount }
    }
    
    var last7DaysSavings: [DailySaving] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: today) ?? today
        
        return dailySavings.filter { saving in
            saving.date >= sevenDaysAgo && saving.date <= today
        }.sorted { $0.date < $1.date }
    }
    
    var last30DaysSavings: [DailySaving] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -29, to: today) ?? today
        
        return dailySavings.filter { saving in
            saving.date >= thirtyDaysAgo && saving.date <= today
        }.sorted { $0.date < $1.date }
    }
    
    var maxDailySaving: Double {
        dailySavings.map { $0.amount }.max() ?? 0
    }
    
    var averageDailySaving: Double {
        guard !dailySavings.isEmpty else { return 0 }
        return totalSaved / Double(dailySavings.count)
    }
    
    // MARK: - Initialization
    init(userSettings: UserSettingsModel) {
        self.userSettings = userSettings
        
        // Новые пользователи начинают без цели - они могут создать свою собственную
        self.savingsGoal = nil
        
        // Подписка на изменения настроек
        userSettings.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    /// Добавляет накопление в копилку
    /// - Note: Вызывается автоматически при завершении дня с оставшимся бюджетом
    func addSaving(amount: Double, date: Date = Date(), note: String? = nil) {
        let saving = DailySaving(date: date, amount: amount, note: note)
        dailySavings.append(saving)
        
        // Обновляем текущую сумму в цели
        if savingsGoal != nil {
            savingsGoal?.currentAmount += amount
        }
    }
    
    func updateSavingsGoal(_ goal: SavingsGoal) {
        savingsGoal = goal
        showingSavingsGoalEditor = false
    }
    
    func openGoalEditor() {
        showingSavingsGoalEditor = true
    }
    
    func withdrawSavings() {
        guard let goal = savingsGoal, isGoalCompleted else { return }
        
        // Создаем завершенную цель для истории
        let completed = CompletedGoal(
            title: goal.title,
            targetAmount: goal.targetAmount,
            achievedAmount: goal.currentAmount,
            startDate: goal.startDate,
            completedDate: Date()
        )
        completedGoals.insert(completed, at: 0) // Добавляем в начало списка
        
        // Очищаем текущую цель и накопления
        savingsGoal = nil
        dailySavings.removeAll()
        
        // Закрываем подтверждение и открываем редактор новой цели
        showingWithdrawConfirmation = false
        
        // Показываем редактор для создания новой цели
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showingSavingsGoalEditor = true
        }
    }
    
    func confirmWithdraw() {
        showingWithdrawConfirmation = true
    }
    
    func getSavingsForDateRange(days: Int) -> [DailySaving] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: today) ?? today
        
        // Создаем словарь для быстрого поиска
        var savingsByDate: [Date: Double] = [:]
        
        for saving in dailySavings {
            let day = calendar.startOfDay(for: saving.date)
            if day >= startDate && day <= today {
                savingsByDate[day, default: 0] += saving.amount
            }
        }
        
        // Создаем массив для всех дней в диапазоне
        var result: [DailySaving] = []
        for dayOffset in 0..<days {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) {
                let amount = savingsByDate[date] ?? 0
                result.append(DailySaving(date: date, amount: amount, note: nil))
            }
        }
        
        return result
    }
}
