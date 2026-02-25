//
//  LocalizationManager.swift
//  Imperial piggy bank
//
//  Created on 25.02.26.
//

import Foundation
import SwiftUI
import Combine

class LocalizationManager: ObservableObject {
    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.code, forKey: "appLanguage")
            objectWillChange.send()
        }
    }
    
    static let shared = LocalizationManager()
    
    init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "appLanguage") {
            self.currentLanguage = AppLanguage.allCases.first(where: { $0.code == savedLanguage }) ?? .english
        } else {
            self.currentLanguage = .english
        }
    }
    
    // MARK: - Onboarding
    struct Onboarding {
        let appTitle: String
        let appSubtitle: String
        let next: String
        let back: String
        let finish: String
        
        // Personal Info
        let introduceYourself: String
        let enterYourData: String
        let lastName: String
        let firstName: String
        let requiredFields: String
        
        // Region & Currency
        let regionAndCurrency: String
        let selectRegionAndCurrency: String
        let region: String
        let currency: String
        let language: String
    }
    
    var onboarding: Onboarding {
        switch currentLanguage {
        case .russian:
            return Onboarding(
                appTitle: "Bank Tower",
                appSubtitle: "Ваш умный помощник\nв управлении финансами",
                next: "Далее",
                back: "Назад",
                finish: "Завершить",
                introduceYourself: "Представьтесь",
                enterYourData: "Введите ваши данные",
                lastName: "Фамилия",
                firstName: "Имя",
                requiredFields: "* Обязательные поля",
                regionAndCurrency: "Регион и валюта",
                selectRegionAndCurrency: "Выберите ваш регион и валюту",
                region: "Регион",
                currency: "Валюта",
                language: "Язык"
            )
        case .english:
            return Onboarding(
                appTitle: "Bank Tower",
                appSubtitle: "Your smart assistant\nfor financial management",
                next: "Next",
                back: "Back",
                finish: "Finish",
                introduceYourself: "Introduce Yourself",
                enterYourData: "Enter your information",
                lastName: "Last Name",
                firstName: "First Name",
                requiredFields: "* Required fields",
                regionAndCurrency: "Region & Currency",
                selectRegionAndCurrency: "Select your region and currency",
                region: "Region",
                currency: "Currency",
                language: "Language"
            )
        case .german:
            return Onboarding(
                appTitle: "Bank Tower",
                appSubtitle: "Ihr intelligenter Assistent\nfür Finanzverwaltung",
                next: "Weiter",
                back: "Zurück",
                finish: "Fertig",
                introduceYourself: "Stellen Sie sich vor",
                enterYourData: "Geben Sie Ihre Daten ein",
                lastName: "Nachname",
                firstName: "Vorname",
                requiredFields: "* Pflichtfelder",
                regionAndCurrency: "Region & Währung",
                selectRegionAndCurrency: "Wählen Sie Ihre Region und Währung",
                region: "Region",
                currency: "Währung",
                language: "Sprache"
            )
        }
    }
    
    // MARK: - Settings
    struct Settings {
        let title: String
        let profile: String
        let edit: String
        let done: String
        let user: String
        let region: String
        let currency: String
        let appearance: String
        let themeTitle: String
        let notifications: String
        let dailySummary: String
        let dailySummaryDescription: String
        let notificationTime: String
        let appVersion: String
        let advancedSettings: String
        let resetOnboarding: String
        let language: String
    }
    
    var settings: Settings {
        switch currentLanguage {
        case .russian:
            return Settings(
                title: "Настройки",
                profile: "Профиль",
                edit: "Изменить",
                done: "Готово",
                user: "Пользователь",
                region: "Регион",
                currency: "Валюта",
                appearance: "Внешний вид",
                themeTitle: "Тема оформления",
                notifications: "Уведомления",
                dailySummary: "Ежедневная сводка",
                dailySummaryDescription: "Получать уведомления о расходах",
                notificationTime: "Время уведомления",
                appVersion: "Версия приложения",
                advancedSettings: "Расширенные настройки",
                resetOnboarding: "Пройти начальную настройку заново",
                language: "Язык"
            )
        case .english:
            return Settings(
                title: "Settings",
                profile: "Profile",
                edit: "Edit",
                done: "Done",
                user: "User",
                region: "Region",
                currency: "Currency",
                appearance: "Appearance",
                themeTitle: "Theme",
                notifications: "Notifications",
                dailySummary: "Daily Summary",
                dailySummaryDescription: "Receive notifications about expenses",
                notificationTime: "Notification Time",
                appVersion: "App Version",
                advancedSettings: "Advanced Settings",
                resetOnboarding: "Repeat Initial Setup",
                language: "Language"
            )
        case .german:
            return Settings(
                title: "Einstellungen",
                profile: "Profil",
                edit: "Bearbeiten",
                done: "Fertig",
                user: "Benutzer",
                region: "Region",
                currency: "Währung",
                appearance: "Aussehen",
                themeTitle: "Theme",
                notifications: "Benachrichtigungen",
                dailySummary: "Tägliche Zusammenfassung",
                dailySummaryDescription: "Benachrichtigungen über Ausgaben erhalten",
                notificationTime: "Benachrichtigungszeit",
                appVersion: "App-Version",
                advancedSettings: "Erweiterte Einstellungen",
                resetOnboarding: "Ersteinrichtung wiederholen",
                language: "Sprache"
            )
        }
    }
    
    // MARK: - Main Screen
    struct Main {
        let title: String
        let greeting: String
        let todayBudget: String
        let spent: String
        let remaining: String
        let todayExpenses: String
        let noExpenses: String
        let addExpense: String
        let addFirstExpenseHint: String
        let expense: String
        let budgetGoal: String
        let dayStats: String
        let goodMorning: String
        let goodAfternoon: String
        let goodEvening: String
        let activities: String
        let tasks: String
        let time: String
        let progress: String
        let days: String
        let noActiveGoal: String
    }
    
    var main: Main {
        switch currentLanguage {
        case .russian:
            return Main(
                title: "Главная",
                greeting: "Добро пожаловать",
                todayBudget: "Бюджет на сегодня",
                spent: "Потрачено",
                remaining: "Осталось",
                todayExpenses: "Траты за сегодня",
                noExpenses: "Нет трат за сегодня",
                addExpense: "Добавить трату",
                addFirstExpenseHint: "Добавьте свою первую трату с помощью кнопки +",
                expense: "Трата",
                budgetGoal: "Цель по бюджету",
                dayStats: "Статистика дня",
                goodMorning: "Доброе утро",
                goodAfternoon: "Добрый день",
                goodEvening: "Добрый вечер",
                activities: "Активности дня",
                tasks: "Задачи",
                time: "Время",
                progress: "Прогресс",
                days: "дней",
                noActiveGoal: "Нет активной цели накопления"
            )
        case .english:
            return Main(
                title: "Main",
                greeting: "Welcome",
                todayBudget: "Today's Budget",
                spent: "Spent",
                remaining: "Remaining",
                todayExpenses: "Today's Expenses",
                noExpenses: "No expenses today",
                addExpense: "Add Expense",
                addFirstExpenseHint: "Add your first expense using the + button",
                expense: "Expense",
                budgetGoal: "Budget Goal",
                dayStats: "Day Statistics",
                goodMorning: "Good Morning",
                goodAfternoon: "Good Afternoon",
                goodEvening: "Good Evening",
                activities: "Today's Activities",
                tasks: "Tasks",
                time: "Time",
                progress: "Progress",
                days: "days",
                noActiveGoal: "No active savings goal"
            )
        case .german:
            return Main(
                title: "Hauptseite",
                greeting: "Willkommen",
                todayBudget: "Tagesbudget",
                spent: "Ausgegeben",
                remaining: "Übrig",
                todayExpenses: "Heutige Ausgaben",
                noExpenses: "Heute keine Ausgaben",
                addExpense: "Ausgabe hinzufügen",
                addFirstExpenseHint: "Fügen Sie Ihre erste Ausgabe mit der +-Taste hinzu",
                expense: "Ausgabe",
                budgetGoal: "Budgetziel",
                dayStats: "Tagesstatistik",
                goodMorning: "Guten Morgen",
                goodAfternoon: "Guten Tag",
                goodEvening: "Guten Abend",
                activities: "Heutige Aktivitäten",
                tasks: "Aufgaben",
                time: "Zeit",
                progress: "Fortschritt",
                days: "Tage",
                noActiveGoal: "Kein aktives Sparziel"
            )
        }
    }
    
    // MARK: - Finance Screen
    struct Finance {
        let title: String
        let budgetPlanning: String
        let expenseManagement: String
        let day: String
        let week: String
        let month: String
        let budget: String
        let planned: String
        let actual: String
        let myFinance: String
        let period: String
        let spent: String
        let remaining: String
        let editBudget: String
        let plannedExpenses: String
        let openPlanner: String
        let expenses: String
        let wallet: String
        let banknote: String
        let arrowDown: String
    }
    
    var finance: Finance {
        switch currentLanguage {
        case .russian:
            return Finance(
                title: "Финансы",
                budgetPlanning: "Планирование бюджета",
                expenseManagement: "Управление расходами",
                day: "День",
                week: "Неделя",
                month: "Месяц",
                budget: "Бюджет",
                planned: "Запланировано",
                actual: "Фактически",
                myFinance: "Мои финансы",
                period: "Период",
                spent: "Потрачено",
                remaining: "Остаток",
                editBudget: "Редактировать бюджет",
                plannedExpenses: "Запланированные траты",
                openPlanner: "Открыть планировщик",
                expenses: "Траты",
                wallet: "Кошелёк",
                banknote: "Банкнота",
                arrowDown: "Стрелка вниз"
            )
        case .english:
            return Finance(
                title: "Finance",
                budgetPlanning: "Budget Planning",
                expenseManagement: "Expense Management",
                day: "Day",
                week: "Week",
                month: "Month",
                budget: "Budget",
                planned: "Planned",
                actual: "Actual",
                myFinance: "My Finance",
                period: "Period",
                spent: "Spent",
                remaining: "Remaining",
                editBudget: "Edit Budget",
                plannedExpenses: "Planned Expenses",
                openPlanner: "Open Planner",
                expenses: "Expenses",
                wallet: "Wallet",
                banknote: "Banknote",
                arrowDown: "Arrow Down"
            )
        case .german:
            return Finance(
                title: "Finanzen",
                budgetPlanning: "Budgetplanung",
                expenseManagement: "Ausgabenverwaltung",
                day: "Tag",
                week: "Woche",
                month: "Monat",
                budget: "Budget",
                planned: "Geplant",
                actual: "Tatsächlich",
                myFinance: "Meine Finanzen",
                period: "Zeitraum",
                spent: "Ausgegeben",
                remaining: "Übrig",
                editBudget: "Budget bearbeiten",
                plannedExpenses: "Geplante Ausgaben",
                openPlanner: "Planer öffnen",
                expenses: "Ausgaben",
                wallet: "Geldbörse",
                banknote: "Banknote",
                arrowDown: "Pfeil nach unten"
            )
        }
    }
    
    // MARK: - Statistics Screen
    struct Statistics {
        let title: String
        let overview: String
        let categories: String
        let trends: String
        let period: String
        let total: String
        let average: String
        let savingsProgress: String
        let weeklyExpenses: String
        let categoryExpenses: String
        let categoryDetails: String
        let recentTransactions: String
        let edit: String
        let noDataYet: String
        let remainingToSave: String
        let daysToGoal: String
        let setSavingsGoal: String
        let addGoal: String
    }
    
    var statistics: Statistics {
        switch currentLanguage {
        case .russian:
            return Statistics(
                title: "Статистика",
                overview: "Обзор",
                categories: "Категории",
                trends: "Тренды",
                period: "Период",
                total: "Всего",
                average: "Среднее",
                savingsProgress: "Прогресс накоплений",
                weeklyExpenses: "Расходы за неделю",
                categoryExpenses: "Расходы по категориям",
                categoryDetails: "Детализация по категориям",
                recentTransactions: "Последние транзакции",
                edit: "Изменить",
                noDataYet: "Пока нет данных",
                remainingToSave: "Осталось накопить",
                daysToGoal: "Дней до цели",
                setSavingsGoal: "Установите цель накопления",
                addGoal: "Добавить цель"
            )
        case .english:
            return Statistics(
                title: "Statistics",
                overview: "Overview",
                categories: "Categories",
                trends: "Trends",
                period: "Period",
                total: "Total",
                average: "Average",
                savingsProgress: "Savings Progress",
                weeklyExpenses: "Weekly Expenses",
                categoryExpenses: "Category Expenses",
                categoryDetails: "Category Details",
                recentTransactions: "Recent Transactions",
                edit: "Edit",
                noDataYet: "No data yet",
                remainingToSave: "Remaining to save",
                daysToGoal: "Days to goal",
                setSavingsGoal: "Set a savings goal",
                addGoal: "Add Goal"
            )
        case .german:
            return Statistics(
                title: "Statistiken",
                overview: "Übersicht",
                categories: "Kategorien",
                trends: "Trends",
                period: "Zeitraum",
                total: "Gesamt",
                average: "Durchschnitt",
                savingsProgress: "Sparfortschritt",
                weeklyExpenses: "Wöchentliche Ausgaben",
                categoryExpenses: "Ausgaben nach Kategorien",
                categoryDetails: "Kategoriedetails",
                recentTransactions: "Letzte Transaktionen",
                edit: "Bearbeiten",
                noDataYet: "Noch keine Daten",
                remainingToSave: "Noch zu sparen",
                daysToGoal: "Tage bis zum Ziel",
                setSavingsGoal: "Sparziel festlegen",
                addGoal: "Ziel hinzufügen"
            )
        }
    }
    
    // MARK: - Piggy Bank Screen
    struct PiggyBank {
        let title: String
        let savingsGoal: String
        let currentAmount: String
        let targetAmount: String
        let progress: String
        let withdraw: String
        let withdrawConfirm: String
        let withdrawMessage: String
        let cancel: String
        let sevenDays: String
        let thirtyDays: String
        let dailySavingsChart: String
        let savingsStatistics: String
        let totalSaved: String
        let averageDaily: String
        let recommendedDaily: String
        let recentSavings: String
        let savingsHistory: String
        let completedGoals: String
        let edit: String
        let target: String
        let calendar: String
        let banknote: String
        let noSavingsYet: String
        let autoSavingsDescription: String
        let defaultGoalTitle: String
        let savingsProgress: String
        let of: String
        let savingsBreakdown: String
        let averageAmount: String
        let perDay: String
        let maxPerDay: String
        let budgetRemainder: String
    }
    
    var piggyBank: PiggyBank {
        switch currentLanguage {
        case .russian:
            return PiggyBank(
                title: "Копилка",
                savingsGoal: "Цель накоплений",
                currentAmount: "Накоплено",
                targetAmount: "Цель",
                progress: "Прогресс",
                withdraw: "Забрать накопления",
                withdrawConfirm: "Забрать накопления?",
                withdrawMessage: "Средства будут сохранены в истории, и вы сможете создать новую цель.",
                cancel: "Отмена",
                sevenDays: "7 дней",
                thirtyDays: "30 дней",
                dailySavingsChart: "График накоплений",
                savingsStatistics: "Статистика накоплений",
                totalSaved: "Всего накоплено",
                averageDaily: "Средняя сумма в день",
                recommendedDaily: "Рекомендуется в день",
                recentSavings: "Последние пополнения",
                savingsHistory: "История накоплений",
                completedGoals: "Завершено целей",
                edit: "Изменить",
                target: "Цель",
                calendar: "Календарь",
                banknote: "Банкнота",
                noSavingsYet: "Пока нет накоплений",
                autoSavingsDescription: "Оставшийся бюджет будет добавляться автоматически",
                defaultGoalTitle: "Моя цель",
                savingsProgress: "Прогресс накоплений",
                of: "из",
                savingsBreakdown: "Детализация накоплений",
                averageAmount: "Средняя сумма",
                perDay: "/день",
                maxPerDay: "Макс. за день",
                budgetRemainder: "Остаток бюджета"
            )
        case .english:
            return PiggyBank(
                title: "Piggy Bank",
                savingsGoal: "Savings Goal",
                currentAmount: "Saved",
                targetAmount: "Goal",
                progress: "Progress",
                withdraw: "Withdraw Savings",
                withdrawConfirm: "Withdraw Savings?",
                withdrawMessage: "The funds will be saved in history, and you can create a new goal.",
                cancel: "Cancel",
                sevenDays: "7 days",
                thirtyDays: "30 days",
                dailySavingsChart: "Savings Chart",
                savingsStatistics: "Savings Statistics",
                totalSaved: "Total Saved",
                averageDaily: "Average per Day",
                recommendedDaily: "Recommended per Day",
                recentSavings: "Recent Savings",
                savingsHistory: "Savings History",
                completedGoals: "Completed Goals",
                edit: "Edit",
                target: "Target",
                calendar: "Calendar",
                banknote: "Banknote",
                noSavingsYet: "No savings yet",
                autoSavingsDescription: "Remaining budget will be added automatically",
                defaultGoalTitle: "My Goal",
                savingsProgress: "Savings Progress",
                of: "of",
                savingsBreakdown: "Savings Breakdown",
                averageAmount: "Average Amount",
                perDay: "/day",
                maxPerDay: "Max per Day",
                budgetRemainder: "Budget Remainder"
            )
        case .german:
            return PiggyBank(
                title: "Sparschwein",
                savingsGoal: "Sparziel",
                currentAmount: "Gespart",
                targetAmount: "Ziel",
                progress: "Fortschritt",
                withdraw: "Ersparnisse abheben",
                withdrawConfirm: "Ersparnisse abheben?",
                withdrawMessage: "Die Mittel werden im Verlauf gespeichert, und Sie können ein neues Ziel erstellen.",
                cancel: "Abbrechen",
                sevenDays: "7 Tage",
                thirtyDays: "30 Tage",
                dailySavingsChart: "Spardiagramm",
                savingsStatistics: "Sparstatistik",
                totalSaved: "Insgesamt gespart",
                averageDaily: "Durchschnitt pro Tag",
                recommendedDaily: "Empfohlen pro Tag",
                recentSavings: "Letzte Einzahlungen",
                savingsHistory: "Sparverlauf",
                completedGoals: "Abgeschlossene Ziele",
                edit: "Bearbeiten",
                target: "Ziel",
                calendar: "Kalender",
                banknote: "Banknote",
                noSavingsYet: "Noch keine Ersparnisse",
                autoSavingsDescription: "Verbleibendes Budget wird automatisch hinzugefügt",
                defaultGoalTitle: "Mein Ziel",
                savingsProgress: "Sparfortschritt",
                of: "von",
                savingsBreakdown: "Spardetails",
                averageAmount: "Durchschnittsbetrag",
                perDay: "/Tag",
                maxPerDay: "Max pro Tag",
                budgetRemainder: "Budgetüberschuss"
            )
        }
    }
    
    // MARK: - Sheets
    struct Sheets {
        let save: String
        let cancel: String
        let done: String
        let add: String
        let delete: String
        let edit: String
        let close: String
        
        // Budget Editor
        let budgetPlanning: String
        let budgetAmount: String
        let enterAmount: String
        let on: String
        
        // Expense Adder
        let newExpense: String
        let quickExpense: String
        let addExpenseForDay: String
        let name: String
        let amount: String
        let category: String
        let forExample: String
        let expensePlaceholder: String
        
        // Expense Planner
        let detailedPlanningDay: String
        let majorExpensesWeek: String
        let mainExpensesMonth: String
        let total: String
        let positions: String
        let addPlanned: String
        let noPlannedExpenses: String
        let addDetailedExpensesDay: String
        let planMajorExpensesWeek: String
        let specifyMainExpensesMonth: String
        let expensePlaceholderDay: String
        let expensePlaceholderWeek: String
        let expensePlaceholderMonth: String
        
        // Savings Goal Editor
        let savingsGoal: String
        let newGoal: String
        let editGoal: String
        let goalName: String
        let goalPlaceholder: String
        let finances: String
        let targetAmount: String
        let alreadySaved: String
        let deadline: String
        let achievementDate: String
        let deleteGoal: String
        
        // Goals History
        let savingsHistory: String
        let historyEmpty: String
        let completedGoals: String
        let completeFirstGoal: String
        let days: String
        let goal: String
        let exceeded: String
        
        // Saving Adder
        let addSaving: String
        let savingAmount: String
        let date: String
        let selectDate: String
        let savingDate: String
        let note: String
        let noteOptional: String
        let notePlaceholder: String
        
        // Daily Summary
        let dailySummary: String
        let dailyBudget: String
        let spent: String
        let saved: String
        let budgetUsage: String
        let great: String
    }
    
    var sheets: Sheets {
        switch currentLanguage {
        case .russian:
            return Sheets(
                save: "Сохранить",
                cancel: "Отмена",
                done: "Готово",
                add: "Добавить",
                delete: "Удалить",
                edit: "Изменить",
                close: "Закрыть",
                budgetPlanning: "Планирование бюджета",
                budgetAmount: "Сумма бюджета",
                enterAmount: "Введите сумму",
                on: "на",
                newExpense: "Новая трата",
                quickExpense: "Быстрая трата",
                addExpenseForDay: "Добавьте расход за день",
                name: "Название",
                amount: "Сумма",
                category: "Категория",
                forExample: "Например:",
                expensePlaceholder: "Название траты",
                detailedPlanningDay: "Детальное планирование на день",
                majorExpensesWeek: "Крупные траты на неделю",
                mainExpensesMonth: "Основные траты на месяц",
                total: "Итого",
                positions: "позиций",
                addPlanned: "Добавить запланированное",
                noPlannedExpenses: "Нет запланированных трат",
                addDetailedExpensesDay: "Добавьте детальные траты на день",
                planMajorExpensesWeek: "Запланируйте крупные траты на неделю",
                specifyMainExpensesMonth: "Укажите основные траты на месяц",
                expensePlaceholderDay: "Название траты",
                expensePlaceholderWeek: "Название траты",
                expensePlaceholderMonth: "Название траты",
                savingsGoal: "Цель накопления",
                newGoal: "Новая цель",
                editGoal: "Редактировать цель",
                goalName: "Название цели",
                goalPlaceholder: "Название цели",
                finances: "Финансы",
                targetAmount: "Целевая сумма",
                alreadySaved: "Уже накоплено",
                deadline: "Срок",
                achievementDate: "Дата достижения цели",
                deleteGoal: "Удалить цель",
                savingsHistory: "История накоплений",
                historyEmpty: "История пуста",
                completedGoals: "Завершено целей",
                completeFirstGoal: "Завершите свою первую цель,\nи она появится здесь",
                days: "дней",
                goal: "Цель:",
                exceeded: "Превышение:",
                addSaving: "Добавить накопление",
                savingAmount: "Сумма накопления",
                date: "Дата",
                selectDate: "Выберите дату",
                savingDate: "Дата накопления",
                note: "Заметка",
                noteOptional: "Заметка (необязательно)",
                notePlaceholder: "Например: Зарплата, подработка...",
                dailySummary: "Итоги дня",
                dailyBudget: "Бюджет дня",
                spent: "Потрачено",
                saved: "Сэкономлено",
                budgetUsage: "Использование бюджета",
                great: "Отлично!"
            )
        case .english:
            return Sheets(
                save: "Save",
                cancel: "Cancel",
                done: "Done",
                add: "Add",
                delete: "Delete",
                edit: "Edit",
                close: "Close",
                budgetPlanning: "Budget Planning",
                budgetAmount: "Budget Amount",
                enterAmount: "Enter amount",
                on: "for",
                newExpense: "New Expense",
                quickExpense: "Quick Expense",
                addExpenseForDay: "Add expense for the day",
                name: "Name",
                amount: "Amount",
                category: "Category",
                forExample: "For example:",
                expensePlaceholder: "Expense name",
                detailedPlanningDay: "Detailed planning for the day",
                majorExpensesWeek: "Major expenses for the week",
                mainExpensesMonth: "Main expenses for the month",
                total: "Total",
                positions: "items",
                addPlanned: "Add planned",
                noPlannedExpenses: "No planned expenses",
                addDetailedExpensesDay: "Add detailed expenses for the day",
                planMajorExpensesWeek: "Plan major expenses for the week",
                specifyMainExpensesMonth: "Specify main expenses for the month",
                expensePlaceholderDay: "Expense name",
                expensePlaceholderWeek: "Expense name",
                expensePlaceholderMonth: "Expense name",
                savingsGoal: "Savings Goal",
                newGoal: "New Goal",
                editGoal: "Edit Goal",
                goalName: "Goal Name",
                goalPlaceholder: "Goal name",
                finances: "Finances",
                targetAmount: "Target Amount",
                alreadySaved: "Already Saved",
                deadline: "Deadline",
                achievementDate: "Achievement Date",
                deleteGoal: "Delete Goal",
                savingsHistory: "Savings History",
                historyEmpty: "History is Empty",
                completedGoals: "Completed Goals",
                completeFirstGoal: "Complete your first goal,\nand it will appear here",
                days: "days",
                goal: "Goal:",
                exceeded: "Exceeded:",
                addSaving: "Add Saving",
                savingAmount: "Saving Amount",
                date: "Date",
                selectDate: "Select Date",
                savingDate: "Saving Date",
                note: "Note",
                noteOptional: "Note (Optional)",
                notePlaceholder: "E.g.: Salary, side job...",
                dailySummary: "Daily Summary",
                dailyBudget: "Daily Budget",
                spent: "Spent",
                saved: "Saved",
                budgetUsage: "Budget Usage",
                great: "Great!"
            )
        case .german:
            return Sheets(
                save: "Speichern",
                cancel: "Abbrechen",
                done: "Fertig",
                add: "Hinzufügen",
                delete: "Löschen",
                edit: "Bearbeiten",
                close: "Schließen",
                budgetPlanning: "Budgetplanung",
                budgetAmount: "Budgetbetrag",
                enterAmount: "Betrag eingeben",
                on: "für",
                newExpense: "Neue Ausgabe",
                quickExpense: "Schnelle Ausgabe",
                addExpenseForDay: "Ausgabe für den Tag hinzufügen",
                name: "Name",
                amount: "Betrag",
                category: "Kategorie",
                forExample: "Zum Beispiel:",
                expensePlaceholder: "Ausgabenname",
                detailedPlanningDay: "Detaillierte Planung für den Tag",
                majorExpensesWeek: "Größere Ausgaben für die Woche",
                mainExpensesMonth: "Hauptausgaben für den Monat",
                total: "Gesamt",
                positions: "Positionen",
                addPlanned: "Geplant hinzufügen",
                noPlannedExpenses: "Keine geplanten Ausgaben",
                addDetailedExpensesDay: "Detaillierte Ausgaben für den Tag hinzufügen",
                planMajorExpensesWeek: "Größere Ausgaben für die Woche planen",
                specifyMainExpensesMonth: "Hauptausgaben für den Monat angeben",
                expensePlaceholderDay: "Ausgabenname",
                expensePlaceholderWeek: "Ausgabenname",
                expensePlaceholderMonth: "Ausgabenname",
                savingsGoal: "Sparziel",
                newGoal: "Neues Ziel",
                editGoal: "Ziel bearbeiten",
                goalName: "Zielname",
                goalPlaceholder: "Zielname",
                finances: "Finanzen",
                targetAmount: "Zielbetrag",
                alreadySaved: "Bereits gespart",
                deadline: "Frist",
                achievementDate: "Erreichungsdatum",
                deleteGoal: "Ziel löschen",
                savingsHistory: "Sparverlauf",
                historyEmpty: "Verlauf ist leer",
                completedGoals: "Abgeschlossene Ziele",
                completeFirstGoal: "Schließen Sie Ihr erstes Ziel ab,\nund es wird hier erscheinen",
                days: "Tage",
                goal: "Ziel:",
                exceeded: "Überschritten:",
                addSaving: "Ersparnis hinzufügen",
                savingAmount: "Sparbetrag",
                date: "Datum",
                selectDate: "Datum auswählen",
                savingDate: "Spardatum",
                note: "Notiz",
                noteOptional: "Notiz (Optional)",
                notePlaceholder: "Z.B.: Gehalt, Nebenjob...",
                dailySummary: "Tagesbilanz",
                dailyBudget: "Tagesbudget",
                spent: "Ausgegeben",
                saved: "Gespart",
                budgetUsage: "Budgetnutzung",
                great: "Großartig!"
            )
        }
    }
    
    // MARK: - Tab Bar
    struct TabBar {
        let main: String
        let finance: String
        let piggyBank: String
        let statistics: String
        let settings: String
    }
    
    var tabBar: TabBar {
        switch currentLanguage {
        case .russian:
            return TabBar(
                main: "Главная",
                finance: "Финансы",
                piggyBank: "Копилка",
                statistics: "Статистика",
                settings: "Настройки"
            )
        case .english:
            return TabBar(
                main: "Main",
                finance: "Finance",
                piggyBank: "Piggy Bank",
                statistics: "Statistics",
                settings: "Settings"
            )
        case .german:
            return TabBar(
                main: "Hauptseite",
                finance: "Finanzen",
                piggyBank: "Sparschwein",
                statistics: "Statistiken",
                settings: "Einstellungen"
            )
        }
    }
    
    // MARK: - Appearance Modes
    func appearanceMode(_ mode: AppearanceMode) -> String {
        switch currentLanguage {
        case .russian:
            switch mode {
            case .system: return "Системная"
            case .light: return "Светлая"
            case .dark: return "Тёмная"
            }
        case .english:
            switch mode {
            case .system: return "System"
            case .light: return "Light"
            case .dark: return "Dark"
            }
        case .german:
            switch mode {
            case .system: return "System"
            case .light: return "Hell"
            case .dark: return "Dunkel"
            }
        }
    }
    
    // MARK: - Currency Names
    func currencyName(_ currency: Currency) -> String {
        switch currentLanguage {
        case .russian:
            switch currency {
            case .ruble: return "₽ Рубль"
            case .dollar: return "$ Доллар"
            case .euro: return "€ Евро"
            case .pound: return "£ Фунт"
            }
        case .english:
            switch currency {
            case .ruble: return "₽ Ruble"
            case .dollar: return "$ Dollar"
            case .euro: return "€ Euro"
            case .pound: return "£ Pound"
            }
        case .german:
            switch currency {
            case .ruble: return "₽ Rubel"
            case .dollar: return "$ Dollar"
            case .euro: return "€ Euro"
            case .pound: return "£ Pfund"
            }
        }
    }
    
    // MARK: - Region Names
    func regionName(_ region: Region) -> String {
        switch currentLanguage {
        case .russian:
            return region.rawValue // Already in Russian
        case .english:
            switch region {
            case .russia: return "Russia"
            case .usa: return "USA"
            case .uk: return "United Kingdom"
            case .germany: return "Germany"
            case .france: return "France"
            case .spain: return "Spain"
            case .italy: return "Italy"
            case .poland: return "Poland"
            case .ukraine: return "Ukraine"
            case .belarus: return "Belarus"
            case .kazakhstan: return "Kazakhstan"
            case .other: return "Other"
            }
        case .german:
            switch region {
            case .russia: return "Russland"
            case .usa: return "USA"
            case .uk: return "Vereinigtes Königreich"
            case .germany: return "Deutschland"
            case .france: return "Frankreich"
            case .spain: return "Spanien"
            case .italy: return "Italien"
            case .poland: return "Polen"
            case .ukraine: return "Ukraine"
            case .belarus: return "Weißrussland"
            case .kazakhstan: return "Kasachstan"
            case .other: return "Andere"
            }
        }
    }
    
    // MARK: - Expense Categories
    struct Categories {
        let food: String
        let transport: String
        let entertainment: String
        let shopping: String
        let other: String
    }
    
    var categories: Categories {
        switch currentLanguage {
        case .russian:
            return Categories(
                food: "Еда",
                transport: "Транспорт",
                entertainment: "Развлечения",
                shopping: "Покупки",
                other: "Прочее"
            )
        case .english:
            return Categories(
                food: "Food",
                transport: "Transport",
                entertainment: "Entertainment",
                shopping: "Shopping",
                other: "Other"
            )
        case .german:
            return Categories(
                food: "Essen",
                transport: "Transport",
                entertainment: "Unterhaltung",
                shopping: "Einkaufen",
                other: "Sonstiges"
            )
        }
    }
    
    /// Возвращает список всех категорий в текущем языке
    var allCategories: [String] {
        return [
            categories.food,
            categories.transport,
            categories.entertainment,
            categories.shopping,
            categories.other
        ]
    }
}
