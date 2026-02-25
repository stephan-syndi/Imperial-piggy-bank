//
//  SavingsGoalEditorSheet.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 20.02.26.
//

import SwiftUI

struct SavingsGoalEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var localization: LocalizationManager
    
    let existingGoal: SavingsGoal?
    let currencySymbol: String
    let onSave: (SavingsGoal) -> Void
    
    @State private var title: String
    @State private var targetAmount: String
    @State private var currentAmount: String
    @State private var deadline: Date
    
    init(existingGoal: SavingsGoal?, currencySymbol: String, onSave: @escaping (SavingsGoal) -> Void) {
        self.existingGoal = existingGoal
        self.currencySymbol = currencySymbol
        self.onSave = onSave
        
        _title = State(initialValue: existingGoal?.title ?? "")
        
        // Безопасное преобразование с проверкой на NaN и Infinite
        let safeTargetAmount = existingGoal?.targetAmount ?? 0
        let safeCurrentAmount = existingGoal?.currentAmount ?? 0
        _targetAmount = State(initialValue: existingGoal != nil && !safeTargetAmount.isNaN && !safeTargetAmount.isInfinite ? "\(Int(safeTargetAmount))" : "")
        _currentAmount = State(initialValue: existingGoal != nil && !safeCurrentAmount.isNaN && !safeCurrentAmount.isInfinite ? "\(Int(safeCurrentAmount))" : "0")
        _deadline = State(initialValue: existingGoal?.deadline ?? Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date())
    }
    
    private var isValid: Bool {
        !title.isEmpty && 
        Double(targetAmount) != nil && 
        (Double(targetAmount) ?? 0) > 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(localization.sheets.savingsGoal) {
                    TextField(localization.sheets.goalPlaceholder, text: $title)
                }
                
                Section(localization.sheets.finances) {
                    HStack {
                        Text(localization.sheets.targetAmount)
                        Spacer()
                        TextField("0", text: $targetAmount)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text(currencySymbol)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text(localization.sheets.alreadySaved)
                        Spacer()
                        TextField("0", text: $currentAmount)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text(currencySymbol)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(localization.sheets.deadline) {
                    DatePicker(
                        localization.sheets.achievementDate,
                        selection: $deadline,
                        in: Date()...,
                        displayedComponents: .date
                    )
                }
                
                if existingGoal != nil {
                    Section {
                        Button(role: .destructive) {
                            // TODO: Добавить удаление цели
                            dismiss()
                        } label: {
                            HStack {
                                Spacer()
                                Text(localization.sheets.deleteGoal)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle(existingGoal == nil ? localization.sheets.newGoal : localization.sheets.editGoal)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(localization.sheets.cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(localization.sheets.save) {
                        saveGoal()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private func saveGoal() {
        guard let target = Double(targetAmount),
              let current = Double(currentAmount) else { return }
        
        let goal = SavingsGoal(
            id: existingGoal?.id ?? UUID(),
            targetAmount: target,
            currentAmount: current,
            deadline: deadline,
            title: title
        )
        
        onSave(goal)
        dismiss()
    }
}

#Preview {
    SavingsGoalEditorSheet(
        existingGoal: SavingsGoal(
            targetAmount: 100000,
            currentAmount: 45000,
            deadline: Date().addingTimeInterval(60 * 60 * 24 * 90),
            title: "MacBook Pro"
        ),
        currencySymbol: "₽",
        onSave: { _ in }
    )
}
