//
//  PiggyBankView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import SwiftUI

struct PiggyBankView: View {
    
    @ObservedObject var viewModel: PiggyBankViewModel
    @State private var selectedPeriod: SavingsPeriod = .month
    @State private var showingHistory = false
    @EnvironmentObject var localization: LocalizationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
                VStack(spacing: 20) {
                    // Прогресс накоплений
                    SavingsProgressView(
                        savingsGoal: viewModel.savingsGoal,
                        currencySymbol: viewModel.currencySymbol,
                        onEdit: {
                            viewModel.openGoalEditor()
                        }
                    )
                    .padding(.horizontal)
                    
                    // Сегментированный прогресс
                    if let goal = viewModel.savingsGoal {
                        SegmentedProgressBar(
                            currentAmount: goal.currentAmount,
                            targetAmount: goal.targetAmount,
                            segments: 10,
                            currencySymbol: viewModel.currencySymbol
                        )
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                    }
                    
                    // Кнопка "Забрать" когда цель достигнута
                    if viewModel.isGoalCompleted {
                        Button(action: {
                            viewModel.confirmWithdraw()
                        }) {
                            HStack {
                                Image(systemName: "banknote")
                                    .font(.title2)
                                Text(localization.piggyBank.withdraw)
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [.orange, .yellow.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Переключатель периода
                    Picker(localization.piggyBank.savingsStatistics, selection: $selectedPeriod) {
                        Text(localization.piggyBank.sevenDays).tag(SavingsPeriod.week)
                        Text(localization.piggyBank.thirtyDays).tag(SavingsPeriod.month)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // График детализации накоплений
                    DailySavingsChart(
                        savings: viewModel.getSavingsForDateRange(days: selectedPeriod.days),
                        days: selectedPeriod.days,
                        currencySymbol: viewModel.currencySymbol
                    )
                    .padding(.horizontal)
                    
                    // Статистика
                    savingsStatistics
                        .padding(.horizontal)
                    
                    // Последние пополнения
                    RecentSavingsList(
                        savings: viewModel.dailySavings,
                        limit: 5,
                        currencySymbol: viewModel.currencySymbol
                    )
                        .padding(.horizontal)
                    
                    // Кнопка истории
                    Button(action: {
                        showingHistory = true
                    }) {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.title3)
                                .foregroundColor(.orange)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(localization.piggyBank.savingsHistory)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("\(localization.piggyBank.completedGoals): \(viewModel.completedGoals.count)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
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
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical)
            }
            .themedBackground(
                .piggyBank,
                appearanceMode: viewModel.userSettings.appearanceMode,
                colorScheme: colorScheme
            )
            .alert(localization.piggyBank.withdrawConfirm, isPresented: $viewModel.showingWithdrawConfirmation) {
                Button(localization.piggyBank.cancel, role: .cancel) { }
                Button(localization.piggyBank.withdraw, role: .destructive) {
                    viewModel.withdrawSavings()
                }
            } message: {
                if let goal = viewModel.savingsGoal {
                    let safeAmount = goal.currentAmount.isNaN || goal.currentAmount.isInfinite ? 0 : goal.currentAmount
                    Text("\(localization.piggyBank.withdrawMessage.replacingOccurrences(of: "[amount]", with: "\(Int(safeAmount)) \(viewModel.currencySymbol)").replacingOccurrences(of: "[title]", with: goal.title))")
                }
            }
            .sheet(isPresented: $showingHistory) {
                GoalsHistorySheet(
                    completedGoals: viewModel.completedGoals,
                    currencySymbol: viewModel.currencySymbol
                )
            }
            .sheet(isPresented: $viewModel.showingSavingsGoalEditor) {
                if let goal = viewModel.savingsGoal {
                    SavingsGoalEditorSheet(
                        existingGoal: goal,
                        currencySymbol: viewModel.currencySymbol,
                        onSave: { updatedGoal in
                            viewModel.updateSavingsGoal(updatedGoal)
                        }
                    )
                } else {
                    SavingsGoalEditorSheet(
                        existingGoal: nil,
                        currencySymbol: viewModel.currencySymbol,
                        onSave: { newGoal in
                            viewModel.updateSavingsGoal(newGoal)
                        }
                    )
                }
            }
        }
    // }
    
    // MARK: - Subviews
    private var savingsStatistics: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(localization.piggyBank.savingsStatistics, systemImage: "chart.line.uptrend.xyaxis")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                let currentAmount = viewModel.savingsGoal?.currentAmount ?? 0
                statisticsRow(
                    title: localization.piggyBank.totalSaved,
                    value: "\(Int(currentAmount.isNaN || currentAmount.isInfinite ? 0 : currentAmount)) \(viewModel.currencySymbol)",
                    icon: "banknote.fill",
                    color: .green
                )
                
                let avgSaving = viewModel.averageDailySaving
                statisticsRow(
                    title: localization.piggyBank.averageDaily,
                    value: "\(Int(avgSaving.isNaN || avgSaving.isInfinite ? 0 : avgSaving)) \(viewModel.currencySymbol)",
                    icon: "calendar",
                    color: .blue
                )
                
                if let goal = viewModel.savingsGoal {
                    let recommendedAmount = goal.recommendedDailyAmount
                    statisticsRow(
                        title: localization.piggyBank.recommendedDaily,
                        value: "\(Int(recommendedAmount.isNaN || recommendedAmount.isInfinite ? 0 : recommendedAmount)) \(viewModel.currencySymbol)",
                        icon: "target",
                        color: .orange
                    )
                }
            }
        }
        .padding()
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color.adaptiveGreen.opacity(0.15),
                        Color.teal.opacity(0.15),
                        Color.adaptiveBlue.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .blur(radius: 0.5)
            }
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.borderColor, lineWidth: 1.5)
        )
        .shadow(color: Color.adaptiveGreen.opacity(0.2), radius: 12, x: 0, y: 6)
    }
    
    private func statisticsRow(title: String, value: String, icon: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 32)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
}

enum SavingsPeriod {
    case week
    case month
    
    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        }
    }
}

#Preview {
    let settings = UserSettingsModel()
    return PiggyBankView(viewModel: PiggyBankViewModel(userSettings: settings))
}
