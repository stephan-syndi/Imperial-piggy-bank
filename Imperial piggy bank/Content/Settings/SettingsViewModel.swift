//
//  SettingsViewModel.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    // MARK: - Models
    @ObservedObject var userSettings: UserSettingsModel
    @ObservedObject var userFinance: UserFinanceModel
    
    // MARK: - UI State
    @Published var isEditingProfile: Bool = false
    
    // MARK: - Temp editing values
    @Published var tempFirstName: String = ""
    @Published var tempLastName: String = ""
    @Published var tempRegion: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var fullName: String {
        userSettings.fullName.isEmpty ? "Пользователь" : userSettings.fullName
    }
    
    var formattedSummaryTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: userSettings.dailySummaryTime)
    }
    
    // MARK: - Инициализация
    init(userSettings: UserSettingsModel, userFinance: UserFinanceModel) {
        self.userSettings = userSettings
        self.userFinance = userFinance
        
        // Инициализируем temp значения
        self.tempFirstName = userSettings.firstName
        self.tempLastName = userSettings.lastName
        self.tempRegion = userSettings.region
        
        // Подписываемся на изменения моделей
        setupSubscriptions()
    }
    
    // MARK: - Private Methods
    private func setupSubscriptions() {
        // Мониторим изменения в userSettings для сохранения
        userSettings.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
                self?.saveSettings()
            }
            .store(in: &cancellables)
    }
    
    private func saveSettings() {
        // TODO: Здесь будет логика сохранения в UserDefaults/CoreData
        // Пока просто обновляем модель
        print("Settings saved")
    }
    
    // MARK: - Public Methods
    
    /// Начать редактирование профиля
    func startEditingProfile() {
        tempFirstName = userSettings.firstName
        tempLastName = userSettings.lastName
        tempRegion = userSettings.region
        isEditingProfile = true
    }
    
    /// Сохранить изменения профиля
    func saveProfileChanges() {
        userSettings.firstName = tempFirstName
        userSettings.lastName = tempLastName
        userSettings.region = tempRegion
        isEditingProfile = false
    }
    
    /// Отменить редактирование профиля
    func cancelEditing() {
        tempFirstName = userSettings.firstName
        tempLastName = userSettings.lastName
        tempRegion = userSettings.region
        isEditingProfile = false
    }
    
    /// Обновить валюту
    func updateCurrency(_ currency: Currency) {
        userSettings.currency = currency
    }
    
    /// Обновить язык
    func updateLanguage(_ language: AppLanguage) {
        userSettings.language = language
        LocalizationManager.shared.currentLanguage = language
    }
    
    /// Обновить режим оформления
    func updateAppearanceMode(_ mode: AppearanceMode) {
        userSettings.appearanceMode = mode
    }
    
    /// Переключить уведомления о ежедневной сводке
    func toggleDailySummary(_ enabled: Bool) {
        userSettings.dailySummaryEnabled = enabled
    }
    
    /// Обновить время ежедневной сводки
    func updateDailySummaryTime(_ time: Date) {
        userSettings.dailySummaryTime = time
    }
    
    /// Получить ежедневную сводку за текущий день
    func getDailySummary() -> DailySummary {
        let totalSpent = userFinance.todaySpent
        let dailyBudget = userFinance.dailyBudget.amount
        let remaining = dailyBudget - totalSpent
        
        return DailySummary(
            date: Date(),
            totalSpent: totalSpent,
            budgetRemaining: max(remaining, 0),
            canTransferToPiggyBank: remaining > 0
        )
    }
    
    /// Перенести остаток бюджета в копилку (вызывается в конце дня)
    func transferRemainingToPiggyBank() {
        let summary = getDailySummary()
        if summary.canTransferToPiggyBank && summary.transferAmount > 0 {
            // TODO: Добавить логику переноса в копилку
            // userFinance.addToPiggyBank(amount: summary.transferAmount)
            print("Transferred \(summary.transferAmount) to piggy bank")
        }
    }
    
    /// Форматировать сумму с учетом валюты
    func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = userSettings.currency.symbol
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "\(userSettings.currency.symbol)\(amount)"
    }
    
    /// Сбросить онбординг (для тестирования или повторной настройки)
    func resetOnboarding() {
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        UserDefaults.standard.synchronize()
    }
    
    /// Очистить все данные приложения
    func clearAllData() {
        DataPersistenceManager.shared.clearAllData()
        resetOnboarding()
    }
}
