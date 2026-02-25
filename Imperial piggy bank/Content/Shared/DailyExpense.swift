//
//  DailyExpense.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import Foundation
import SwiftUI

struct DailyExpense: Identifiable, Codable {
    let id: UUID
    let icon: String
    let title: String
    let time: String
    let amount: Double
    let date: Date
    let category: String
    
    // Color не Codable, поэтому храним hex строку
    private let colorHex: String
    
    var color: Color {
        Color(hex: colorHex) ?? .gray
    }
    
    init(id: UUID = UUID(), icon: String, title: String, time: String, amount: Double, color: Color, date: Date = Date(), category: String = "") {
        self.id = id
        self.icon = icon
        self.title = title
        self.time = time
        self.amount = amount
        self.colorHex = color.toHex()
        self.date = date
        self.category = category
    }
    
    init(id: UUID = UUID(), time: String, amount: Double){
        self.id = id
        self.time = time
        self.amount = amount
        self.date = Date()
        // ToDo
        self.icon = ""
        self.title = ""
        self.colorHex = "#000000"
        self.category = ""
    }
}
