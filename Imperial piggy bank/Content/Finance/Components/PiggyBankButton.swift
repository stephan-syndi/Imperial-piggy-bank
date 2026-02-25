//
//  PiggyBankButton.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 24.02.26.
//

import SwiftUI

struct PiggyBankButton: View {
    let progressPercentage: Double
    let viewModel: PiggyBankViewModel
    
    var body: some View {
        NavigationLink(destination: PiggyBankView(viewModel: viewModel)) {
            HStack(spacing: 6) {
                // Иконка копилки
                Image(systemName: "dollarsign.bank.building.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.pink, .purple.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Полоска прогресса с процентами
                ZStack {
                    // Фон полоски
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.progressTrack)
                        .frame(width: 44, height: 16)
                    
                    // Заполненная часть
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [.pink, .purple.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(progressPercentage / 100))
                    }
                    .frame(height: 16)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    // Текст с процентами
                    Text("\(Int(progressPercentage))%")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 16)
            }
        }
    }
}

#Preview {
    NavigationView {
        VStack {
            Text("Finance View")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                PiggyBankButton(
                    progressPercentage: 45,
                    viewModel: PiggyBankViewModel(userSettings: UserSettingsModel())
                )
            }
        }
    }
}
