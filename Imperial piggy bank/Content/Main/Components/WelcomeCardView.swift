//
//  WelcomeCardView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct WelcomeCardView: View {
    let userName: String
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(localization.main.greeting), \(userName)!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            Text(getGreeting())
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .fontWeight(.medium)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.orange.opacity(0.8),
                        Color.yellow.opacity(0.7),
                        Color.pink.opacity(0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Блики
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .offset(x: -50, y: -30)
                    .blur(radius: 20)
            }
        )
        .cornerRadius(20)
        .shadow(color: .orange.opacity(0.4), radius: 15, x: 0, y: 8)
    }
    
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return localization.main.goodMorning
        case 12..<18:
            return localization.main.goodAfternoon
        default:
            return localization.main.goodEvening
        }
    }
}
