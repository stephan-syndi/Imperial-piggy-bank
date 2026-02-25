//
//  SavingAdderSheet.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import SwiftUI

struct SavingAdderSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localization: LocalizationManager
    let onSave: (Double, Date, String?) -> Void
    
    @State private var amount: String = ""
    @State private var selectedDate: Date = Date()
    @State private var note: String = ""
    @State private var showDatePicker: Bool = false
    
    private var isValidAmount: Bool {
        guard let value = Double(amount) else { return false }
        return value > 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Image(systemName: "rublesign.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                        
                        TextField("0", text: $amount)
                            .keyboardType(.decimalPad)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                } header: {
                    Text(localization.sheets.savingAmount)
                }
                
                Section {
                    Button(action: {
                        showDatePicker.toggle()
                    }) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            Text(localization.sheets.date)
                            Spacer()
                            Text(selectedDate, style: .date)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if showDatePicker {
                        DatePicker(
                            localization.sheets.selectDate,
                            selection: $selectedDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                    }
                } header: {
                    Text(localization.sheets.savingDate)
                }
                
                Section {
                    TextField(localization.sheets.notePlaceholder, text: $note, axis: .vertical)
                        .lineLimit(3...5)
                } header: {
                    Text(localization.sheets.noteOptional)
                }
            }
            .navigationTitle(localization.sheets.addSaving)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(localization.sheets.cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(localization.sheets.add) {
                        if let value = Double(amount) {
                            onSave(value, selectedDate, note.isEmpty ? nil : note)
                            dismiss()
                        }
                    }
                    .disabled(!isValidAmount)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    SavingAdderSheet { amount, date, note in
        print("Added: \(amount)₽ on \(date)")
    }
    .environmentObject(LocalizationManager.shared)
}
