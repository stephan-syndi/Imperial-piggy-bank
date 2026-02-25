//
//  ExpensePlannerSheet.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct ExpensePlannerSheet: View {
    @Binding var plannedExpenses: [PlannedExpense]
    let period: TimePeriod
    let categories: [String]
    let currencySymbol: String
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localization: LocalizationManager
    
    @State private var newTitle: String = ""
    @State private var newAmount: String = ""
    @State private var newCategory: String = ""
    @State private var selectedDate: Date = Date()
    @State private var showDatePicker: Bool = false
    
    var periodTitle: String {
        switch localization.currentLanguage {
        case .russian:
            switch period {
            case .day: return localization.sheets.detailedPlanningDay
            case .week: return localization.sheets.majorExpensesWeek
            case .month: return localization.sheets.mainExpensesMonth
            }
        case .english:
            switch period {
            case .day: return localization.sheets.detailedPlanningDay
            case .week: return localization.sheets.majorExpensesWeek
            case .month: return localization.sheets.mainExpensesMonth
            }
        case .german:
            switch period {
            case .day: return localization.sheets.detailedPlanningDay
            case .week: return localization.sheets.majorExpensesWeek
            case .month: return localization.sheets.mainExpensesMonth
            }
        }
    }
    
    var totalPlanned: Double {
        plannedExpenses.reduce(0) { $0 + $1.amount }
    }
    
    var emptyStateMessage: String {
        switch period {
        case .day: return localization.sheets.addDetailedExpensesDay
        case .week: return localization.sheets.planMajorExpensesWeek
        case .month: return localization.sheets.specifyMainExpensesMonth
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Заголовок с итоговой суммой
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(periodTitle)
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("\(plannedExpenses.count) \(localization.sheets.positions)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(localization.sheets.total)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.0f \(currencySymbol)", totalPlanned))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                        }
                    }
                    .padding()
                    .background(Color.inputFieldBackground)
                    .cornerRadius(12)
                }
                .padding()
                
                // Форма добавления траты
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        TextField(period == .day ? localization.sheets.expensePlaceholderDay : period == .week ? localization.sheets.expensePlaceholderWeek : localization.sheets.expensePlaceholderMonth, text: $newTitle)
                            .padding()
                            .background(Color.inputFieldBackground)
                            .cornerRadius(8)
                        
                        HStack(spacing: 4) {
                            TextField("0", text: $newAmount)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                            Text(currencySymbol)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.inputFieldBackground)
                        .cornerRadius(8)
                    }
                    
                    HStack(spacing: 8) {
                        Menu {
                            ForEach(categories, id: \.self) { cat in
                                Button(cat) {
                                    newCategory = cat
                                }
                            }
                        } label: {
                            HStack {
                                Text(newCategory)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.inputFieldBackground)
                            .cornerRadius(8)
                        }
                        
                        if period == .day {
                            Button(action: {
                                showDatePicker.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "calendar")
                                    Text(selectedDate, style: .date)
                                        .lineLimit(1)
                                }
                                .font(.subheadline)
                                .padding()
                                .background(Color.inputFieldBackground)
                                .cornerRadius(8)
                            }
                        }
                        
                        Button(action: addExpense) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(newTitle.isEmpty || newAmount.isEmpty ? .gray : .purple)
                        }
                        .disabled(newTitle.isEmpty || newAmount.isEmpty)
                    }
                    
                    if showDatePicker && period == .day {
                        DatePicker(localization.sheets.achievementDate, selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .padding()
                            .background(Color.inputFieldBackground)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color.cardBackground)
                
                Divider()
                
                // Список запланированных трат
                ScrollView {
                    if plannedExpenses.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            Text(localization.sheets.noPlannedExpenses)
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text(emptyStateMessage)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 60)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(plannedExpenses) { expense in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(expense.title)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        HStack(spacing: 4) {
                                            Text(expense.category)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            if let date = expense.date, period == .day {
                                                Text("•")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Text(date, style: .date)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Text(String(format: "%.0f \(currencySymbol)", expense.amount))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.purple)
                                    
                                    Button(action: {
                                        deleteExpense(expense)
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.subheadline)
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding()
                                .background(Color.inputFieldBackground)
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                }
                
                // Кнопка закрытия
                Button(action: { dismiss() }) {
                    Text(localization.sheets.done)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(12)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            // Установка категории по умолчанию при первом открытии
            if newCategory.isEmpty {
                newCategory = categories.first ?? localization.categories.food
            }
        }
    }
    
    private func addExpense() {
        guard let amount = Double(newAmount), !newTitle.isEmpty else { return }
        
        let expense = PlannedExpense(
            title: newTitle,
            amount: amount,
            category: newCategory,
            date: period == .day ? selectedDate : nil
        )
        
        plannedExpenses.append(expense)
        
        // Очистка полей
        newTitle = ""
        newAmount = ""
        newCategory = categories.first ?? localization.categories.food
        selectedDate = Date()
    }
    
    private func deleteExpense(_ expense: PlannedExpense) {
        plannedExpenses.removeAll { $0.id == expense.id }
    }
}

#Preview {
    ExpensePlannerSheet(
        plannedExpenses: .constant([]),
        period: .day,
        categories: ["Еда", "Транспорт", "Развлечения", "Покупки", "Прочее"],
        currencySymbol: "₽"
    )
}
