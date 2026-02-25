//
//  DateHeaderView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 17.02.26.
//

import SwiftUI

struct DateHeaderView: View {
    let currentDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(currentDate, format: .dateTime.weekday(.wide))
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))
            Text(currentDate, format: .dateTime.day().month().year())
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.7),
                    Color.pink.opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}
