//
//  DataPersistenceManager.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 25.02.26.
//

import Foundation
import Combine

/// Менеджер для сохранения и загрузки данных приложения
class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // Keys для UserDefaults
    private enum Keys {
        static let userFinance = "userFinanceData"
        static let userSettings = "userSettingsData"
        static let piggyBankData = "piggyBankData"
    }
    
    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - UserFinanceModel
    
    func saveUserFinance(_ model: UserFinanceModel) {
        do {
            let data = try encoder.encode(model)
            userDefaults.set(data, forKey: Keys.userFinance)
            userDefaults.synchronize()
        } catch {
            print("❌ Error saving UserFinanceModel: \(error)")
        }
    }
    
    func loadUserFinance() -> UserFinanceModel? {
        guard let data = userDefaults.data(forKey: Keys.userFinance) else {
            return nil
        }
        
        do {
            let model = try decoder.decode(UserFinanceModel.self, from: data)
            return model
        } catch {
            print("❌ Error loading UserFinanceModel: \(error)")
            return nil
        }
    }
    
    // MARK: - UserSettingsModel
    
    func saveUserSettings(_ model: UserSettingsModel) {
        do {
            let data = try encoder.encode(model)
            userDefaults.set(data, forKey: Keys.userSettings)
            userDefaults.synchronize()
        } catch {
            print("❌ Error saving UserSettingsModel: \(error)")
        }
    }
    
    func loadUserSettings() -> UserSettingsModel? {
        guard let data = userDefaults.data(forKey: Keys.userSettings) else {
            return nil
        }
        
        do {
            let model = try decoder.decode(UserSettingsModel.self, from: data)
            return model
        } catch {
            print("❌ Error loading UserSettingsModel: \(error)")
            return nil
        }
    }
    
    // MARK: - PiggyBankData
    
    func savePiggyBankData(_ goal: SavingsGoal?, savings: [DailySaving], completedGoals: [CompletedGoal]) {
        let data = PiggyBankData(
            savingsGoal: goal,
            dailySavings: savings,
            completedGoals: completedGoals
        )
        
        do {
            let encoded = try encoder.encode(data)
            userDefaults.set(encoded, forKey: Keys.piggyBankData)
            userDefaults.synchronize()
        } catch {
            print("❌ Error saving PiggyBankData: \(error)")
        }
    }
    
    func loadPiggyBankData() -> PiggyBankData? {
        guard let data = userDefaults.data(forKey: Keys.piggyBankData) else {
            return nil
        }
        
        do {
            let decoded = try decoder.decode(PiggyBankData.self, from: data)
            return decoded
        } catch {
            print("❌ Error loading PiggyBankData: \(error)")
            return nil
        }
    }
    
    // MARK: - Clear All Data
    
    func clearAllData() {
        userDefaults.removeObject(forKey: Keys.userFinance)
        userDefaults.removeObject(forKey: Keys.userSettings)
        userDefaults.removeObject(forKey: Keys.piggyBankData)
        userDefaults.synchronize()
    }
}

// MARK: - Supporting Types

struct PiggyBankData: Codable {
    let savingsGoal: SavingsGoal?
    let dailySavings: [DailySaving]
    let completedGoals: [CompletedGoal]
}
