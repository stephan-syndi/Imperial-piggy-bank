//
//  SettingsView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 5.02.26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 1. Профиль пользователя
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(localization.settings.profile)
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            Button(action: {
                                if viewModel.isEditingProfile {
                                    viewModel.saveProfileChanges()
                                } else {
                                    viewModel.startEditingProfile()
                                }
                            }) {
                                Text(viewModel.isEditingProfile ? localization.settings.done : localization.settings.edit)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            // Аватар и имя
                            HStack(spacing: 16) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    if viewModel.isEditingProfile {
                                        TextField("Имя", text: $viewModel.tempFirstName)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                        TextField("Фамилия", text: $viewModel.tempLastName)
                                            .font(.subheadline)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                    } else {
                                        Text(viewModel.fullName)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                        Text(localization.settings.user)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            
                            Divider()
                            
                            // Регион
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                
                                Text(localization.settings.region)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if viewModel.isEditingProfile {
                                    TextField("Регион", text: $viewModel.tempRegion)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text(viewModel.userSettings.region)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            
                            Divider()
                            
                            // Валюта
                            HStack {
                                Image(systemName: "rublesign.circle")
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                
                                Text(localization.settings.currency)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if viewModel.isEditingProfile {
                                    Menu {
                                        ForEach(Currency.allCases, id: \.self) { currency in
                                            Button(localization.currencyName(currency)) {
                                                viewModel.updateCurrency(currency)
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(localization.currencyName(viewModel.userSettings.currency))
                                                .foregroundColor(.secondary)
                                            Image(systemName: "chevron.down")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                } else {
                                    Text(localization.currencyName(viewModel.userSettings.currency))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                        }
                        .background(
                            ZStack {
                                LinearGradient(
                                    colors: [
                                        Color.adaptivePurple.opacity(0.1),
                                        Color.pink.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardBackground)
                                    .blur(radius: 0.5)
                            }
                        )
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.borderColor, lineWidth: 1.5)
                        )
                        .shadow(color: Color.adaptivePurple.opacity(0.15), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    
                    // 2. Внешний вид приложения
                    VStack(alignment: .leading, spacing: 16) {
                        Text(localization.settings.appearance)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "paintbrush.fill")
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                
                                Text(localization.settings.themeTitle)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            .padding()
                            
                            Divider()
                            
                            // Выбор темы
                            HStack(spacing: 12) {
                                ForEach(AppearanceMode.allCases, id: \.self) { mode in
                                    AppearanceModeButton(
                                        mode: mode,
                                        isSelected: viewModel.userSettings.appearanceMode == mode,
                                        action: { viewModel.updateAppearanceMode(mode) }
                                    )
                                }
                            }
                            .padding()
                        }
                        .background(
                            ZStack {
                                LinearGradient(
                                    colors: [
                                        Color.adaptiveOrange.opacity(0.1),
                                        Color.adaptiveYellow.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardBackground)
                                    .blur(radius: 0.5)
                            }
                        )
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.borderColor, lineWidth: 1.5)
                        )
                        .shadow(color: Color.adaptiveOrange.opacity(0.15), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    
                    // Язык
                    VStack(alignment: .leading, spacing: 16) {
                        Text(localization.settings.language)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                
                                Text(localization.settings.language)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Menu {
                                    ForEach(AppLanguage.allCases, id: \.self) { language in
                                        Button(language.displayName) {
                                            viewModel.updateLanguage(language)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(viewModel.userSettings.language.displayName)
                                            .foregroundColor(.secondary)
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding()
                        }
                        .background(
                            ZStack {
                                LinearGradient(
                                    colors: [
                                        Color.adaptiveGreen.opacity(0.1),
                                        Color.teal.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardBackground)
                                    .blur(radius: 0.5)
                            }
                        )
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.borderColor, lineWidth: 1.5)
                        )
                        .shadow(color: Color.adaptiveGreen.opacity(0.15), radius: 10, x: 0, y: 5)
                        .shadow(color: .green.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    
                    // 3. Уведомления
                    VStack(alignment: .leading, spacing: 16) {
                        Text(localization.settings.notifications)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            // Включение уведомлений
                            HStack {
                                Image(systemName: "bell.fill")
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(localization.settings.dailySummary)
                                        .foregroundColor(.primary)
                                    Text(localization.settings.dailySummaryDescription)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: Binding(
                                    get: { viewModel.userSettings.dailySummaryEnabled },
                                    set: { viewModel.toggleDailySummary($0) }
                                ))
                                    .labelsHidden()
                            }
                            .padding()
                            
                            if viewModel.userSettings.dailySummaryEnabled {
                                Divider()
                                
                                // Время уведомления
                                HStack {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(.blue)
                                        .frame(width: 24)
                                    
                                    Text(localization.settings.notificationTime)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    DatePicker("", selection: Binding(
                                        get: { viewModel.userSettings.dailySummaryTime },
                                        set: { viewModel.updateDailySummaryTime($0) }
                                    ), displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                }
                                .padding()
                            }
                        }
                        .background(
                            ZStack {
                                LinearGradient(
                                    colors: [
                                        Color.indigo.opacity(0.1),
                                        Color.adaptivePurple.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardBackground)
                                    .blur(radius: 0.5)
                            }
                        )
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.borderColor, lineWidth: 1.5)
                        )
                        .shadow(color: Color.indigo.opacity(0.15), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    
                    // Дополнительная информация
                    VStack(spacing: 12) {
                        HStack {
                            Text(localization.settings.appVersion)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(viewModel.userSettings.appVersion)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(
                            ZStack {
                                LinearGradient(
                                    colors: [
                                        Color.adaptiveOrange.opacity(0.1),
                                        Color.adaptiveYellow.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardBackground)
                                    .blur(radius: 0.5)
                            }
                        )
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.borderColor, lineWidth: 1.5)
                        )
                        .shadow(color: Color.adaptiveOrange.opacity(0.15), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    
                    // Расширенные настройки
                    VStack(alignment: .leading, spacing: 16) {
                        Text(localization.settings.advancedSettings)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        Button(action: {
                            viewModel.resetOnboarding()
                            // Перезапустить приложение можно через выход и повторный вход
                            exit(0)
                        }) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                    .foregroundColor(.orange)
                                    .frame(width: 24)
                                
                                Text(localization.settings.resetOnboarding)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(
                                ZStack {
                                    LinearGradient(
                                        colors: [
                                            Color.red.opacity(0.15),
                                            Color.orange.opacity(0.15)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.cardBackground)
                                        .blur(radius: 0.5)
                                }
                            )
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.borderColor, lineWidth: 1.5)
                            )
                            .shadow(color: Color.adaptiveRed.opacity(0.15), radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.vertical)
            }
            .themedBackground(
                .settings,
                appearanceMode: viewModel.userSettings.appearanceMode,
                colorScheme: colorScheme
            )
            .navigationTitle(localization.settings.title)
        }
    }
}

// Компонент кнопки выбора темы
struct AppearanceModeButton: View {
    let mode: AppearanceMode
    let isSelected: Bool
    let action: () -> Void
    @ObservedObject private var localization = LocalizationManager.shared
    
    var iconName: String {
        switch mode {
        case .system:
            return "gear"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .blue)
                    .frame(width: 50, height: 50)
                    .background(isSelected ? Color.blue : Color.blue.opacity(0.1))
                    .clipShape(Circle())
                
                Text(localization.appearanceMode(mode))
                    .font(.caption)
                    .foregroundColor(isSelected ? .blue : .secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    let userSettings = UserSettingsModel()
    let userFinance = UserFinanceModel()
    let viewModel = SettingsViewModel(userSettings: userSettings, userFinance: userFinance)
    
    return SettingsView(viewModel: viewModel)
}
