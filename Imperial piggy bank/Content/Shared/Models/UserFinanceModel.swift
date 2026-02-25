//
//  UserFinanceModel.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import Foundation
import SwiftUI
import Combine

/// Структура для хранения бюджета по периоду
struct PeriodBudget: Codable {
    var amount: Double
    var lastUpdated: Date
    
    init(amount: Double = 0, lastUpdated: Date = Date()) {
        self.amount = amount
        self.lastUpdated = lastUpdated
    }
}

/// Структура для хранения планируемых трат по периоду
struct PeriodPlannedExpenses: Codable {
    var expenses: [PlannedExpense]
    
    init(expenses: [PlannedExpense] = []) {
        self.expenses = expenses
    }
    
    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
}

/// Структура для хранения данных итогов дня
struct DailySummaryData: Codable, Hashable {
    let date: Date
    let budget: Double
    let spent: Double
    let saved: Double
    
    init(date: Date, budget: Double, spent: Double) {
        self.date = date
        self.budget = budget
        self.spent = spent
        self.saved = max(budget - spent, 0)
    }
}

/// Основная модель пользовательских финансовых данных
class UserFinanceModel: ObservableObject, Codable {
    // MARK: - Бюджеты по периодам
    @Published var dailyBudget: PeriodBudget
    @Published var weeklyBudget: PeriodBudget
    @Published var monthlyBudget: PeriodBudget
    
    // MARK: - Планируемые траты по периодам
    @Published var dailyPlannedExpenses: PeriodPlannedExpenses
    @Published var weeklyPlannedExpenses: PeriodPlannedExpenses
    @Published var monthlyPlannedExpenses: PeriodPlannedExpenses
    
    // MARK: - Совершенные траты за текущий день
    @Published var todayExpenses: [DailyExpense]
    
    // MARK: - Отслеживание смены дня
    /// Последняя активная дата (для определения смены дня)
    @Published var lastActiveDate: Date
    
    /// История трат по дням (дата → массив трат)
    @Published var expenseHistory: [Date: [DailyExpense]]
    
    // MARK: - Итоги дня
    /// Множество дат, для которых были просмотрены итоги
    @Published var viewedSummaryDates: Set<Date>
    
    /// Хранилище данных об итогах за прошлые дни (для истории)
    @Published var dailySummaryHistory: [Date: DailySummaryData]
    
    // MARK: - Вычисляемые свойства
    
    /// Общая сумма трат за сегодня
    var todaySpent: Double {
        todayExpenses.reduce(0) { $0 + $1.amount }
    }
    
    /// Остаток дневного бюджета
    var dailyRemaining: Double {
        dailyBudget.amount - todaySpent
    }
    
    /// Процент использования дневного бюджета
    var dailySpentPercentage: Double {
        guard dailyBudget.amount > 0 else { return 0 }
        return min(todaySpent / dailyBudget.amount, 1.0)
    }
    
    // MARK: - Инициализация
    
    init() {
        self.dailyBudget = PeriodBudget(amount: 0)
        self.weeklyBudget = PeriodBudget(amount: 0)
        self.monthlyBudget = PeriodBudget(amount: 0)
        
        self.dailyPlannedExpenses = PeriodPlannedExpenses()
        self.weeklyPlannedExpenses = PeriodPlannedExpenses()
        self.monthlyPlannedExpenses = PeriodPlannedExpenses()
        
        self.todayExpenses = []
        self.lastActiveDate = Calendar.current.startOfDay(for: Date())
        self.expenseHistory = [:]
        self.viewedSummaryDates = []
        self.dailySummaryHistory = [:]
        
        // Проверяем смену дня при инициализации
        checkAndHandleDayChange()
    }
    
    // MARK: - Методы управления бюджетом
    
    /// Устанавливает бюджет для указанного периода
    func setBudget(_ amount: Double, for period: TimePeriod) {
        let budget = PeriodBudget(amount: amount, lastUpdated: Date())
        switch period {
        case .day:
            dailyBudget = budget
        case .week:
            weeklyBudget = budget
        case .month:
            monthlyBudget = budget
        }
    }
    
    /// Получает бюджет для указанного периода
    func getBudget(for period: TimePeriod) -> PeriodBudget {
        switch period {
        case .day:
            return dailyBudget
        case .week:
            return weeklyBudget
        case .month:
            return monthlyBudget
        }
    }
    
    // MARK: - Методы управления планируемыми тратами
    
    /// Добавляет планируемую трату для указанного периода
    func addPlannedExpense(_ expense: PlannedExpense, for period: TimePeriod) {
        switch period {
        case .day:
            dailyPlannedExpenses.expenses.append(expense)
        case .week:
            weeklyPlannedExpenses.expenses.append(expense)
        case .month:
            monthlyPlannedExpenses.expenses.append(expense)
        }
    }
    
    /// Удаляет планируемую трату
    func removePlannedExpense(_ expense: PlannedExpense, from period: TimePeriod) {
        switch period {
        case .day:
            dailyPlannedExpenses.expenses.removeAll { $0.id == expense.id }
        case .week:
            weeklyPlannedExpenses.expenses.removeAll { $0.id == expense.id }
        case .month:
            monthlyPlannedExpenses.expenses.removeAll { $0.id == expense.id }
        }
    }
    
    /// Получает планируемые траты для указанного периода
    func getPlannedExpenses(for period: TimePeriod) -> [PlannedExpense] {
        switch period {
        case .day:
            return dailyPlannedExpenses.expenses
        case .week:
            return weeklyPlannedExpenses.expenses
        case .month:
            return monthlyPlannedExpenses.expenses
        }
    }
    
    /// Общая сумма планируемых трат для периода
    func totalPlannedAmount(for period: TimePeriod) -> Double {
        switch period {
        case .day:
            return dailyPlannedExpenses.totalAmount
        case .week:
            return weeklyPlannedExpenses.totalAmount
        case .month:
            return monthlyPlannedExpenses.totalAmount
        }
    }
    
    // MARK: - Методы управления совершенными тратами
    
    /// Добавляет новую совершенную трату
    func addExpense(title: String, amount: Double, category: String) {
        let colorForCategory = categoryColor(for: category)
        let iconForCategory = categoryIcon(for: category)
        let now = Date()
        let timeString = DateFormatter.localizedString(from: now, dateStyle: .none, timeStyle: .short)
        
        let expense = DailyExpense(
            icon: iconForCategory,
            title: title,
            time: timeString,
            amount: amount,
            color: colorForCategory,
            date: now,
            category: category
        )
        todayExpenses.insert(expense, at: 0)
    }
    
    /// Удаляет совершенную трату
    func removeExpense(_ expense: DailyExpense) {
        todayExpenses.removeAll { $0.id == expense.id }
    }
    
    // MARK: - Методы управления сменой дня
    
    /// Проверяет, изменился ли день, и выполняет необходимые действия
    func checkAndHandleDayChange() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastActive = calendar.startOfDay(for: lastActiveDate)
        
        // Если день изменился
        if !calendar.isDate(today, inSameDayAs: lastActive) {
            handleDayChange(from: lastActive, to: today)
        }
        
        // Обновляем последнюю активную дату
        lastActiveDate = today
    }
    
    /// Обработка смены дня
    private func handleDayChange(from previousDay: Date, to currentDay: Date) {
        // 1. Сохраняем траты предыдущего дня в историю
        if !todayExpenses.isEmpty {
            expenseHistory[previousDay] = todayExpenses
        }
        
        // 2. Сохраняем итоги предыдущего дня
        let summary = DailySummaryData(
            date: previousDay,
            budget: dailyBudget.amount,
            spent: todaySpent
        )
        dailySummaryHistory[previousDay] = summary
        
        // 3. Очищаем траты текущего дня
        todayExpenses.removeAll()
        
        // 4. Рассчитываем и устанавливаем бюджет на новый день
        let newDailyBudget = calculateDailyBudgetForNewDay()
        dailyBudget = PeriodBudget(amount: newDailyBudget, lastUpdated: currentDay)
    }
    
    /// Рассчитывает бюджет на новый день с учетом недельного лимита
    private func calculateDailyBudgetForNewDay() -> Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Если недельный бюджет не установлен или равен 0, используем стандартный дневной
        guard weeklyBudget.amount > 0 else {
            return dailyBudget.amount
        }
        
        // Находим начало текущей недели (понедельник)
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start else {
            return dailyBudget.amount
        }
        
        // Подсчитываем общие траты за текущую неделю
        var weeklySpent: Double = 0
        
        // Проходим по всем дням текущей недели до вчерашнего дня
        for dayOffset in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek),
                  day < today else {
                break
            }
            
            // Суммируем траты из истории
            if let expenses = expenseHistory[day] {
                weeklySpent += expenses.reduce(0) { $0 + $1.amount }
            }
            
            // Или из итогов
            if let summary = dailySummaryHistory[day] {
                weeklySpent += summary.spent
            }
        }
        
        // Рассчитываем оставшийся недельный бюджет
        let remainingWeeklyBudget = max(weeklyBudget.amount - weeklySpent, 0)
        
        // Определяем количество оставшихся дней в неделе (включая сегодня)
        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek) ?? today
        let remainingDays = calendar.dateComponents([.day], from: today, to: endOfWeek).day ?? 1
        let daysLeft = max(remainingDays, 1)
        
        // Делим оставшийся бюджет на оставшиеся дни
        let calculatedDailyBudget = remainingWeeklyBudget / Double(daysLeft)
        
        // Возвращаем меньшее значение из рассчитанного и стандартного дневного бюджета
        // Это гарантирует, что мы не превысим недельный лимит
        if dailyBudget.amount > 0 {
            return min(calculatedDailyBudget, dailyBudget.amount)
        } else {
            return calculatedDailyBudget
        }
    }
    
    // MARK: - Методы управления итогами дня
    
    /// Создает или извлекает итоги для указанного дня
    func createDailySummary(for date: Date) -> DailySummaryData {
        let dateKey = Calendar.current.startOfDay(for: date)
        
        // Если итоги для этого дня уже сохранены, возвращаем их
        if let existingSummary = dailySummaryHistory[dateKey] {
            return existingSummary
        }
        
        // Создаем новые итоги
        // Примечание: это работает корректно только для текущего дня
        // В будущем нужно добавить хранение исторических данных о тратах
        let summary = DailySummaryData(
            date: dateKey,
            budget: dailyBudget.amount,
            spent: todaySpent
        )
        
        // Сохраняем в историю
        dailySummaryHistory[dateKey] = summary
        
        return summary
    }
    
    /// Сохраняет итоги текущего дня (вызывается при наступлении времени подсчета)
    func saveTodaySummary() {
        let today = Calendar.current.startOfDay(for: Date())
        
        // Не сохраняем повторно, если уже есть
        guard dailySummaryHistory[today] == nil else { return }
        
        let summary = DailySummaryData(
            date: today,
            budget: dailyBudget.amount,
            spent: todaySpent
        )
        
        dailySummaryHistory[today] = summary
    }
    
    /// Отмечает, что итоги дня были просмотрены
    func markSummaryAsViewed(for date: Date) {
        let dateKey = Calendar.current.startOfDay(for: date)
        viewedSummaryDates.insert(dateKey)
    }
    
    /// Проверяет, были ли просмотрены итоги для указанного дня
    func isSummaryViewed(for date: Date) -> Bool {
        let dateKey = Calendar.current.startOfDay(for: date)
        return viewedSummaryDates.contains(dateKey)
    }
    
    // MARK: - Вспомогательные методы
    
    private func categoryIcon(for category: String) -> String {
        let localization = LocalizationManager.shared
        switch category {
        case localization.categories.food: return "cart.fill"
        case localization.categories.transport: return "bus.fill"
        case localization.categories.entertainment: return "gamecontroller.fill"
        case localization.categories.shopping: return "bag.fill"
        default: return "questionmark.circle.fill"
        }
    }
    
    private func categoryColor(for category: String) -> Color {
        let localization = LocalizationManager.shared
        switch category {
        case localization.categories.food: return .orange
        case localization.categories.transport: return .blue
        case localization.categories.entertainment: return .purple
        case localization.categories.shopping: return .pink
        default: return .gray
        }
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case dailyBudget, weeklyBudget, monthlyBudget
        case dailyPlannedExpenses, weeklyPlannedExpenses, monthlyPlannedExpenses
        case todayExpenses
        case lastActiveDate, expenseHistory
        case viewedSummaryDates, dailySummaryHistory
        case lastViewedSummaryDate // Для обратной совместимости
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        dailyBudget = try container.decode(PeriodBudget.self, forKey: .dailyBudget)
        weeklyBudget = try container.decode(PeriodBudget.self, forKey: .weeklyBudget)
        monthlyBudget = try container.decode(PeriodBudget.self, forKey: .monthlyBudget)
        
        dailyPlannedExpenses = try container.decode(PeriodPlannedExpenses.self, forKey: .dailyPlannedExpenses)
        weeklyPlannedExpenses = try container.decode(PeriodPlannedExpenses.self, forKey: .weeklyPlannedExpenses)
        monthlyPlannedExpenses = try container.decode(PeriodPlannedExpenses.self, forKey: .monthlyPlannedExpenses)
        
        todayExpenses = try container.decode([DailyExpense].self, forKey: .todayExpenses)
        
        lastActiveDate = try container.decodeIfPresent(Date.self, forKey: .lastActiveDate) ?? Calendar.current.startOfDay(for: Date())
        expenseHistory = try container.decodeIfPresent([Date: [DailyExpense]].self, forKey: .expenseHistory) ?? [:]
        
        // Поддержка миграции со старой версии
        if let oldDate = try container.decodeIfPresent(Date.self, forKey: .lastViewedSummaryDate) {
            viewedSummaryDates = [oldDate]
        } else {
            viewedSummaryDates = try container.decodeIfPresent(Set<Date>.self, forKey: .viewedSummaryDates) ?? []
        }
        dailySummaryHistory = try container.decodeIfPresent([Date: DailySummaryData].self, forKey: .dailySummaryHistory) ?? [:]
        
        // Проверяем смену дня после загрузки
        checkAndHandleDayChange()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(dailyBudget, forKey: .dailyBudget)
        try container.encode(weeklyBudget, forKey: .weeklyBudget)
        try container.encode(monthlyBudget, forKey: .monthlyBudget)
        
        try container.encode(dailyPlannedExpenses, forKey: .dailyPlannedExpenses)
        try container.encode(weeklyPlannedExpenses, forKey: .weeklyPlannedExpenses)
        try container.encode(monthlyPlannedExpenses, forKey: .monthlyPlannedExpenses)
        
        try container.encode(todayExpenses, forKey: .todayExpenses)
        
        try container.encode(lastActiveDate, forKey: .lastActiveDate)
        try container.encode(expenseHistory, forKey: .expenseHistory)
        
        try container.encode(viewedSummaryDates, forKey: .viewedSummaryDates)
        try container.encode(dailySummaryHistory, forKey: .dailySummaryHistory)
    }
}

// MARK: - Extensions для Codable конформанса зависимых типов

extension PlannedExpense: Codable {
    enum CodingKeys: String, CodingKey {
        case id, title, amount, category, date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let amount = try container.decode(Double.self, forKey: .amount)
        let category = try container.decode(String.self, forKey: .category)
        let date = try container.decodeIfPresent(Date.self, forKey: .date)
        
        self.init(id: id, title: title, amount: amount, category: category, date: date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(amount, forKey: .amount)
        try container.encode(category, forKey: .category)
        try container.encodeIfPresent(date, forKey: .date)
    }
}
