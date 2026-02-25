//
//  MainViewModel.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import Foundation
import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    // Ссылка на общую модель финансов
    @ObservedObject var userFinance: UserFinanceModel
    // Ссылка на модель настроек пользователя
    @ObservedObject var userSettings: UserSettingsModel
    // Ссылка на модель копилки
    @ObservedObject var piggyBankViewModel: PiggyBankViewModel
    
    @Published var currentDate = Date()
    @Published var dayStats: DayStats
    
    @Published var showExpenseAdder = false
    @Published var newExpenseTitle = ""
    @Published var newExpenseAmount = ""
    @Published var newExpenseCategory: String
    
    // Для показа итогов дня
    @Published var showDailySummary = false
    @Published var dailySummaryToShow: DailySummaryData?
    
    // Флаг для отслеживания, что проверка попапа уже была выполнена в текущей сессии
    private var hasCheckedSummaryInCurrentSession = false
    private var lastCheckDate: Date?
    
    // Множество дат, для которых уже сохранили остаток в копилку
    private var datesWithSavingsTransferred: Set<Date> = []
    
    var categories: [String] {
        LocalizationManager.shared.allCategories
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // Computed properties из UserFinanceModel
    var budgetInfo: BudgetInfo {
        BudgetInfo(
            dailyBudget: userFinance.dailyBudget.amount,
            spent: userFinance.todaySpent
        )
    }
    
    var expenses: [DailyExpense] {
        userFinance.todayExpenses
    }
    
    // Прогресс копилки
    var savingsProgress: SavingsProgress? {
        guard let goal = piggyBankViewModel.savingsGoal else { return nil }
        return SavingsProgress(
            goalTitle: goal.title,
            targetAmount: goal.targetAmount,
            currentAmount: goal.currentAmount,
            progressPercentage: goal.progressPercentage,
            daysRemaining: goal.daysRemaining
        )
    }
    
    // Computed properties из UserSettingsModel
    var userName: String {
        let name = userSettings.fullName
        return name.isEmpty ? "Пользователь" : name
    }
    
    var currencySymbol: String {
        userSettings.currency.symbol
    }
    
    init(userFinance: UserFinanceModel, userSettings: UserSettingsModel, piggyBankViewModel: PiggyBankViewModel) {
        self.userFinance = userFinance
        self.userSettings = userSettings
        self.piggyBankViewModel = piggyBankViewModel
        // Инициализация с пустыми данными для новых пользователей
        self.dayStats = DayStats(tasksCompleted: 0, totalTasks: 0, plannedHours: 0)
        // Устанавливаем первую категорию из локализованного списка
        self.newExpenseCategory = LocalizationManager.shared.categories.food
        
        // Подписка на изменения userFinance и userSettings
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
    
    // MARK: - Методы управления итогами дня
    
    /// Проверяет, нужно ли показать итоги дня и показывает их при необходимости
    func checkAndShowDailySummary() {
        // Сначала проверяем и обрабатываем смену дня
        userFinance.checkAndHandleDayChange()
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Проверяем, изменилась ли дата с момента последней проверки
        if let lastCheck = lastCheckDate, calendar.isDate(lastCheck, inSameDayAs: today) {
            // Если проверка уже была выполнена сегодня, не повторяем
            guard !hasCheckedSummaryInCurrentSession else { return }
        } else {
            // Новый день - сбрасываем флаг
            hasCheckedSummaryInCurrentSession = false
        }
        
        // Отмечаем, что проверка выполнена
        hasCheckedSummaryInCurrentSession = true
        lastCheckDate = today
        
        guard userSettings.dailySummaryEnabled else { return }
        
        let now = Date()
        let summaryTime = userSettings.dailySummaryTime
        
        // Получаем компоненты времени из настроек
        let summaryHour = calendar.component(.hour, from: summaryTime)
        let summaryMinute = calendar.component(.minute, from: summaryTime)
        
        // Создаем время подсчета итогов для сегодня
        if let todaySummaryTime = calendar.date(bySettingHour: summaryHour, minute: summaryMinute, second: 0, of: today),
           now >= todaySummaryTime {
            // Если время подсчета для сегодня уже наступило, сохраняем итоги текущего дня
            userFinance.saveTodaySummary()
        }
        
        // Ищем последний день, для которого нужно показать итоги
        // Проверяем последние 7 дней (НЕ включая сегодня)
        for daysAgo in 1...7 {
            guard let targetDate = calendar.date(byAdding: .day, value: -daysAgo, to: now),
                  let targetSummaryTime = calendar.date(bySettingHour: summaryHour, minute: summaryMinute, second: 0, of: targetDate) else {
                continue
            }
            
            // Проверяем, прошло ли время подсчета итогов для этого дня
            guard now >= targetSummaryTime else {
                continue
            }
            
            // Если итоги для этого дня еще не просмотрены, показываем их
            if !userFinance.isSummaryViewed(for: targetDate) {
                // Перед показом попапа сохраняем остаток в копилку (если еще не сохранили)
                transferDailyRemainingToPiggyBank(for: targetDate)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.dailySummaryToShow = self.userFinance.createDailySummary(for: targetDate)
                    self.showDailySummary = true
                }
                return // Показываем только один попап за раз
            }
        }
    }
    
    /// Отмечает итоги дня как просмотренные и закрывает попап
    func markSummaryAsViewed() {
        if let summary = dailySummaryToShow {
            userFinance.markSummaryAsViewed(for: summary.date)
            // Еще раз проверяем, что остаток был сохранен в копилку
            transferDailyRemainingToPiggyBank(for: summary.date)
        }
        showDailySummary = false
        dailySummaryToShow = nil
    }
    
    /// Переносит остаток дневного бюджета в копилку для указанной даты
    private func transferDailyRemainingToPiggyBank(for date: Date) {
        let calendar = Calendar.current
        let dateKey = calendar.startOfDay(for: date)
        
        // Проверяем, не сохраняли ли мы уже для этой даты
        guard !datesWithSavingsTransferred.contains(dateKey) else {
            return
        }
        
        // Получаем итоги за этот день
        guard let summary = userFinance.dailySummaryHistory[dateKey] else {
            return
        }
        
        // Если есть сбережения (остаток > 0), добавляем в копилку
        if summary.saved > 0 {
            let localization = LocalizationManager.shared
            let note = localization.piggyBank.budgetRemainder
            piggyBankViewModel.addSaving(amount: summary.saved, date: date, note: note)
            
            // Отмечаем, что для этой даты мы уже сохранили
            datesWithSavingsTransferred.insert(dateKey)
            
            print("💰 Transferred \(summary.saved)\(currencySymbol) to piggy bank for \(date)")
        }
    }
    
    // MARK: - Методы управления тратами
    
    func addExpense() {
        guard let amount = Double(newExpenseAmount), !newExpenseTitle.isEmpty else { return }
        
        // Добавляем трату через UserFinanceModel
        userFinance.addExpense(
            title: newExpenseTitle,
            amount: amount,
            category: newExpenseCategory
        )
        
        // Очистка полей
        newExpenseTitle = ""
        newExpenseAmount = ""
        newExpenseCategory = LocalizationManager.shared.categories.food
        showExpenseAdder = false
        
        // Уведомляем об изменениях
        objectWillChange.send()
    }
    
}
