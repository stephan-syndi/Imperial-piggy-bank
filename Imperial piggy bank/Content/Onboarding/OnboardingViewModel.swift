//
//  OnboardingViewModel.swift
//  Imperial piggy bank
//
//  Created on 25.02.26.
//

import Foundation
import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentStep: OnboardingStep = .welcome
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var selectedRegion: Region = .russia
    @Published var selectedCurrency: Currency = .ruble
    @Published var selectedLanguage: AppLanguage = .english
    
    let userSettings: UserSettingsModel
    private let localizationManager = LocalizationManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var canProceedFromPersonalInfo: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var canComplete: Bool {
        canProceedFromPersonalInfo
    }
    
    var progressValue: Double {
        Double(currentStep.rawValue) / Double(OnboardingStep.complete.rawValue)
    }
    
    // MARK: - Initialization
    init(userSettings: UserSettingsModel) {
        self.userSettings = userSettings
        
        // Устанавливаем английский язык по умолчанию
        self.localizationManager.currentLanguage = .english
        
        // Автоматически подстраиваем валюту под выбранный регион
        $selectedRegion
            .sink { [weak self] region in
                self?.selectedCurrency = region.defaultCurrency
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation Methods
    func nextStep() {
        withAnimation {
            switch currentStep {
            case .welcome:
                currentStep = .personalInfo
            case .personalInfo:
                if canProceedFromPersonalInfo {
                    currentStep = .regionAndCurrency
                }
            case .regionAndCurrency:
                currentStep = .complete
            case .complete:
                break
            }
        }
    }
    
    func previousStep() {
        withAnimation {
            switch currentStep {
            case .welcome:
                break
            case .personalInfo:
                currentStep = .welcome
            case .regionAndCurrency:
                currentStep = .personalInfo
            case .complete:
                currentStep = .regionAndCurrency
            }
        }
    }
    
    // MARK: - Completion Method
    func completeOnboarding() {
        // Сохраняем данные в UserSettings
        userSettings.firstName = firstName.trimmingCharacters(in: .whitespaces)
        userSettings.lastName = lastName.trimmingCharacters(in: .whitespaces)
        userSettings.region = selectedRegion.rawValue
        userSettings.currency = selectedCurrency
        userSettings.language = selectedLanguage
        
        // Синхронизируем язык с LocalizationManager
        localizationManager.currentLanguage = selectedLanguage
        
        // Отмечаем, что онбординг завершен
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Static Helper
    static func hasCompletedOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    static func resetOnboarding() {
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        UserDefaults.standard.synchronize()
    }
}
