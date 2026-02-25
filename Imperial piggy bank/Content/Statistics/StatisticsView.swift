//
//  StatisticsView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 5.02.26.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Statistics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .navigationTitle("Statistics")
        }
    }
}

#Preview {
    StatisticsView()
}
