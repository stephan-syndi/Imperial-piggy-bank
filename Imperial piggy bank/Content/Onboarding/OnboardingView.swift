//
//  OnboardingView.swift
//  Imperial piggy bank
//
//  Created on 25.02.26.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel: OnboardingViewModel
    @Binding var isOnboardingComplete: Bool
    @ObservedObject private var localization = LocalizationManager.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Фоновый градиент
            ThemeManager.backgroundGradient(
                for: .onboarding,
                appearanceMode: viewModel.userSettings.appearanceMode,
                colorScheme: colorScheme
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Прогресс бар
                if viewModel.currentStep != .welcome {
                    ProgressView(value: viewModel.progressValue)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                }
                
                // Контент в зависимости от текущего шага (без свайпов)
                ZStack {
                    if viewModel.currentStep == .welcome {
                        WelcomeStepView(viewModel: viewModel)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if viewModel.currentStep == .personalInfo {
                        PersonalInfoStepView(viewModel: viewModel)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if viewModel.currentStep == .regionAndCurrency {
                        RegionCurrencyStepView(viewModel: viewModel)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Кнопки навигации
                HStack(spacing: 15) {
                    if viewModel.currentStep != .welcome {
                        Button(action: {
                            viewModel.previousStep()
                        }) {
                            Text(localization.onboarding.back)
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(15)
                        }
                    }
                    
                    Button(action: {
                        if viewModel.currentStep == .regionAndCurrency {
                            viewModel.completeOnboarding()
                            isOnboardingComplete = true
                        } else {
                            viewModel.nextStep()
                        }
                    }) {
                        Text(viewModel.currentStep == .regionAndCurrency ? localization.onboarding.finish : localization.onboarding.next)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                viewModel.currentStep == .personalInfo && !viewModel.canProceedFromPersonalInfo
                                    ? Color.gray.opacity(0.5)
                                    : Color.white.opacity(0.3)
                            )
                            .cornerRadius(15)
                    }
                    .disabled(viewModel.currentStep == .personalInfo && !viewModel.canProceedFromPersonalInfo)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Welcome Step
struct WelcomeStepView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Иконка приложения
            Image(ImageResource.logo)
                .resizable()
                .frame(width: 426, height: 238)
                .scaledToFill()
                .padding(.bottom, 20)
            

            Text(localization.onboarding.appSubtitle)
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            
            // Выбор языка
            VStack(alignment: .leading, spacing: 8) {
                Text(localization.onboarding.language)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.leading, 5)
                
                Menu {
                    ForEach(AppLanguage.allCases, id: \.self) { language in
                        Button(action: {
                            viewModel.selectedLanguage = language
                            localization.currentLanguage = language
                        }) {
                            HStack {
                                Text(language.displayName)
                                if viewModel.selectedLanguage == language {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedLanguage.displayName)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.inputFieldBackground)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 50)
            
            Spacer()
            Spacer()
        }
    }
}

// MARK: - Personal Info Step
struct PersonalInfoStepView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    @FocusState private var focusedField: Field?
    
    enum Field {
        case lastName, firstName
    }
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            VStack(spacing: 15) {
                Text(localization.onboarding.introduceYourself)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text(localization.onboarding.enterYourData)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 15) {
                // Фамилия
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(localization.onboarding.lastName) *")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.leading, 5)
                    
                    TextField("", text: $viewModel.lastName)
                        .textFieldStyle(OnboardingTextFieldStyle())
                        .focused($focusedField, equals: .lastName)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .firstName
                        }
                }
                
                // Имя
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(localization.onboarding.firstName) *")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.leading, 5)
                    
                    TextField("", text: $viewModel.firstName)
                        .textFieldStyle(OnboardingTextFieldStyle())
                        .focused($focusedField, equals: .firstName)
                        .submitLabel(.done)
                        .onSubmit {
                            focusedField = nil
                        }
                }
            }
            .padding(.horizontal, 30)
            
            Text(localization.onboarding.requiredFields)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            Spacer()
        }
    }
}

// MARK: - Region & Currency Step
struct RegionCurrencyStepView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            VStack(spacing: 15) {
                Text(localization.onboarding.regionAndCurrency)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text(localization.onboarding.selectRegionAndCurrency)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                // Выбор региона
                VStack(alignment: .leading, spacing: 8) {
                    Text(localization.onboarding.region)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.leading, 5)
                    
                    Menu {
                        ForEach(Region.allCases, id: \.self) { region in
                            Button(action: {
                                viewModel.selectedRegion = region
                            }) {
                                HStack {
                                    Text(localization.regionName(region))
                                    if viewModel.selectedRegion == region {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(localization.regionName(viewModel.selectedRegion))
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                }
                
                // Выбор валюты
                VStack(alignment: .leading, spacing: 8) {
                    Text(localization.onboarding.currency)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.leading, 5)
                    
                    Menu {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Button(action: {
                                viewModel.selectedCurrency = currency
                            }) {
                                HStack {
                                    Text(localization.currencyName(currency))
                                    if viewModel.selectedCurrency == currency {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(localization.currencyName(viewModel.selectedCurrency))
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.inputFieldBackground)
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
            Spacer()
        }
    }
}

// MARK: - Custom Text Field Style
struct OnboardingTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.inputFieldBackground)
            .cornerRadius(12)
            .font(.body)
    }
}

// MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(
            viewModel: OnboardingViewModel(userSettings: UserSettingsModel()),
            isOnboardingComplete: .constant(false)
        )
    }
}
