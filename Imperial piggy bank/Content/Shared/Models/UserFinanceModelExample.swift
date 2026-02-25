//
//  UserFinanceModelExample.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//
//  Примеры использования UserFinanceModel

import Foundation
import SwiftUI

/// Примеры работы с UserFinanceModel
class UserFinanceModelExample {
    
    // MARK: - Пример 1: Базовая инициализация и работа с бюджетом
    func example1_BasicBudgetSetup() {
        let userFinance = UserFinanceModel()
        
        // Установка бюджетов
        userFinance.setBudget(5000, for: .day)
        userFinance.setBudget(35000, for: .week)
        userFinance.setBudget(150000, for: .month)
        
        // Получение бюджета
        let dailyBudget = userFinance.getBudget(for: .day)
        print("Дневной бюджет: \(dailyBudget.amount) ₽")
        print("Обновлен: \(dailyBudget.lastUpdated)")
    }
    
    // MARK: - Пример 2: Добавление и отслеживание трат
    func example2_AddingExpenses() {
        let userFinance = UserFinanceModel()
        userFinance.setBudget(5000, for: .day)
        
        // Добавление трат
        userFinance.addExpense(title: "Кофе", amount: 250, category: "Еда")
        userFinance.addExpense(title: "Такси", amount: 450, category: "Транспорт")
        userFinance.addExpense(title: "Обед", amount: 800, category: "Еда")
        
        // Проверка статуса бюджета
        print("Потрачено сегодня: \(userFinance.todaySpent) ₽")
        print("Остаток: \(userFinance.dailyRemaining) ₽")
        print("Использовано: \(Int(userFinance.dailySpentPercentage * 100))%")
        
        // Список всех трат
        print("\nТраты за сегодня:")
        for expense in userFinance.todayExpenses {
            print("- \(expense.title): \(expense.amount) ₽ в \(expense.time)")
        }
    }
    
    // MARK: - Пример 3: Планирование трат
    func example3_PlannedExpenses() {
        let userFinance = UserFinanceModel()
        
        // Планируем траты на неделю
        let groceries = PlannedExpense(
            title: "Продукты на неделю",
            amount: 8000,
            category: "Еда",
            date: Date().addingTimeInterval(86400) // Завтра
        )
        
        let gym = PlannedExpense(
            title: "Спортзал",
            amount: 3000,
            category: "Развлечения",
            date: Date().addingTimeInterval(86400 * 3) // Через 3 дня
        )
        
        userFinance.addPlannedExpense(groceries, for: .week)
        userFinance.addPlannedExpense(gym, for: .week)
        
        // Проверка планируемых трат
        let weeklyPlanned = userFinance.getPlannedExpenses(for: .week)
        let totalPlanned = userFinance.totalPlannedAmount(for: .week)
        
        print("Запланировано на неделю: \(totalPlanned) ₽")
        print("Количество запланированных трат: \(weeklyPlanned.count)")
        
        for expense in weeklyPlanned {
            print("- \(expense.title): \(expense.amount) ₽")
        }
    }
    
    // MARK: - Пример 4: Полный цикл управления финансами
    func example4_FullFinanceManagement() {
        let userFinance = UserFinanceModel()
        
        // 1. Настройка бюджетов
        userFinance.setBudget(5000, for: .day)
        userFinance.setBudget(35000, for: .week)
        
        // 2. Планирование трат на день
        let breakfast = PlannedExpense(
            title: "Завтрак",
            amount: 500,
            category: "Еда"
        )
        userFinance.addPlannedExpense(breakfast, for: .day)
        
        // 3. Совершение запланированной траты
        userFinance.addExpense(
            title: breakfast.title,
            amount: breakfast.amount,
            category: breakfast.category
        )
        
        // 4. Удаление выполненной запланированной траты
        userFinance.removePlannedExpense(breakfast, from: .day)
        
        // 5. Добавление незапланированной траты
        userFinance.addExpense(
            title: "Кофе в кафе",
            amount: 350,
            category: "Еда"
        )
        
        // 6. Проверка статуса
        print("=== Статус финансов ===")
        print("Бюджет на день: \(userFinance.getBudget(for: .day).amount) ₽")
        print("Потрачено: \(userFinance.todaySpent) ₽")
        print("Остаток: \(userFinance.dailyRemaining) ₽")
        print("Запланировано: \(userFinance.totalPlannedAmount(for: .day)) ₽")
        
        let remaining = userFinance.dailyRemaining
        let planned = userFinance.totalPlannedAmount(for: .day)
        let available = remaining - planned
        print("Доступно после планов: \(available) ₽")
    }
    
    // MARK: - Пример 5: Сохранение и загрузка данных
    func example5_PersistenceExample() {
        // Создание и наполнение модели
        let userFinance = UserFinanceModel()
        userFinance.setBudget(5000, for: .day)
        userFinance.addExpense(title: "Обед", amount: 600, category: "Еда")
        
        do {
            // Сохранение
            let encoder = JSONEncoder()
            let data = try encoder.encode(userFinance)
            UserDefaults.standard.set(data, forKey: "userFinanceData")
            print("Данные сохранены")
            
            // Загрузка
            let decoder = JSONDecoder()
            if let savedData = UserDefaults.standard.data(forKey: "userFinanceData") {
                let loadedFinance = try decoder.decode(UserFinanceModel.self, from: savedData)
                print("Загружено трат: \(loadedFinance.todayExpenses.count)")
                print("Загружен бюджет: \(loadedFinance.getBudget(for: .day).amount) ₽")
            }
        } catch {
            print("Ошибка при работе с данными: \(error)")
        }
    }
    
    // MARK: - Пример 6: Разные периоды
    func example6_MultiPeriodManagement() {
        let userFinance = UserFinanceModel()
        
        // Настройка всех периодов
        userFinance.setBudget(3000, for: .day)
        userFinance.setBudget(20000, for: .week)
        userFinance.setBudget(80000, for: .month)
        
        // Планирование для разных периодов
        let dailySnack = PlannedExpense(title: "Перекус", amount: 300, category: "Еда")
        let weeklyGym = PlannedExpense(title: "Абонемент", amount: 5000, category: "Развлечения")
        let monthlyRent = PlannedExpense(title: "Аренда", amount: 35000, category: "Прочее")
        
        userFinance.addPlannedExpense(dailySnack, for: .day)
        userFinance.addPlannedExpense(weeklyGym, for: .week)
        userFinance.addPlannedExpense(monthlyRent, for: .month)
        
        // Вывод информации по всем периодам
        let periods: [TimePeriod] = [.day, .week, .month]
        for period in periods {
            print("\n=== \(period.rawValue) ===")
            print("Бюджет: \(userFinance.getBudget(for: period).amount) ₽")
            print("Запланировано: \(userFinance.totalPlannedAmount(for: period)) ₽")
            print("Количество планов: \(userFinance.getPlannedExpenses(for: period).count)")
        }
    }
}
