//
//  ContentView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 5.02.26.
//

import SwiftUI
import Combine

struct ContentView: View {
    // Единая модель финансов для всего приложения
    @StateObject private var userFinance: UserFinanceModel
    @StateObject private var userSettings: UserSettingsModel
    @StateObject private var mainViewModel: MainViewModel
    @StateObject private var myFinanceViewModel: MyFinanceViewModel
    @StateObject private var statisticsViewModel: StatisticsViewModel
    @StateObject private var piggyBankViewModel: PiggyBankViewModel
    @StateObject private var settingsViewModel: SettingsViewModel
    @StateObject private var onboardingViewModel: OnboardingViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    
    // Отслеживаем завершение онбординга
    @State private var isOnboardingComplete: Bool = OnboardingViewModel.hasCompletedOnboarding()
    @State private var selectedTab: Int = 0
    
    init() {
        // Загружаем сохраненные данные или создаем новые
        let finance = DataPersistenceManager.shared.loadUserFinance() ?? UserFinanceModel()
        let settings = DataPersistenceManager.shared.loadUserSettings() ?? UserSettingsModel()
        
        _userFinance = StateObject(wrappedValue: finance)
        _userSettings = StateObject(wrappedValue: settings)
        
        // Загружаем данные копилки
        let piggyVM = PiggyBankViewModel(userSettings: settings)
        if let piggyData = DataPersistenceManager.shared.loadPiggyBankData() {
            piggyVM.savingsGoal = piggyData.savingsGoal
            piggyVM.dailySavings = piggyData.dailySavings
            piggyVM.completedGoals = piggyData.completedGoals
        }
        
        _piggyBankViewModel = StateObject(wrappedValue: piggyVM)
        _mainViewModel = StateObject(wrappedValue: MainViewModel(userFinance: finance, userSettings: settings, piggyBankViewModel: piggyVM))
        _myFinanceViewModel = StateObject(wrappedValue: MyFinanceViewModel(userFinance: finance, userSettings: settings, piggyBankViewModel: piggyVM))
        _statisticsViewModel = StateObject(wrappedValue: StatisticsViewModel(userFinance: finance, userSettings: settings, piggyBankViewModel: piggyVM))
        _settingsViewModel = StateObject(wrappedValue: SettingsViewModel(userSettings: settings, userFinance: finance))
        _onboardingViewModel = StateObject(wrappedValue: OnboardingViewModel(userSettings: settings))
        
        // Синхронизируем язык при запуске
        LocalizationManager.shared.currentLanguage = settings.language
    }
    
    var body: some View {
        if isOnboardingComplete {
            mainContent
                .preferredColorScheme(colorScheme(for: userSettings.appearanceMode))
                .onReceive(userFinance.objectWillChange) { _ in
                    saveUserFinance()
                }
                .onReceive(userSettings.objectWillChange) { _ in
                    saveUserSettings()
                }
                .onReceive(piggyBankViewModel.objectWillChange) { _ in
                    savePiggyBankData()
                }
        } else {
            OnboardingView(viewModel: onboardingViewModel, isOnboardingComplete: $isOnboardingComplete)
                .environmentObject(localization)
                .preferredColorScheme(colorScheme(for: userSettings.appearanceMode))
        }
    }
    
    // MARK: - Auto-save Methods
    
    private func saveUserFinance() {
        DataPersistenceManager.shared.saveUserFinance(userFinance)
    }
    
    private func saveUserSettings() {
        DataPersistenceManager.shared.saveUserSettings(userSettings)
    }
    
    private func savePiggyBankData() {
        DataPersistenceManager.shared.savePiggyBankData(
            piggyBankViewModel.savingsGoal,
            savings: piggyBankViewModel.dailySavings,
            completedGoals: piggyBankViewModel.completedGoals
        )
    }
    
  
    private var mainContent: some View {
        TabView(selection: $selectedTab) {
            MainView(
                viewModel: mainViewModel,
                onFinanceTap: {
                    myFinanceViewModel.openBudgetEditor()
                    selectedTab = 1
                }
            )
                .tabItem {
                    Label(localization.tabBar.main, systemImage: "house.fill")
                }
                .tag(0)
            
            MyFinanceView(viewModel: myFinanceViewModel)
                .tabItem {
                    Label(localization.tabBar.finance, systemImage: "dollarsign.circle.fill")
                }
                .tag(1)
            
            StatisticsView(viewModel: statisticsViewModel)
                .tabItem {
                    Label(localization.tabBar.statistics, systemImage: "chart.bar.fill")
                }
                .tag(2)
            
            SettingsView(viewModel: settingsViewModel)
                .tabItem {
                    Label(localization.tabBar.settings, systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .environmentObject(localization)
    }
    
    /// Преобразовать AppearanceMode в ColorScheme
    private func colorScheme(for mode: AppearanceMode) -> ColorScheme? {
        switch mode {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocalizationManager())
}
