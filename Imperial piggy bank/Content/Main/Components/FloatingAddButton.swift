//
//  FloatingAddButton.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct FloatingAddButton: View {
    let action: () -> Void
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text(localization.main.expense)
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.red, Color.orange, Color.pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(30)
                    .shadow(color: .red.opacity(0.6), radius: 15, x: 0, y: 8)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
}
