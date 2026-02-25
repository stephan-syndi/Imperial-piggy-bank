//
//  MyFinanceView.swift
//  Imperial piggy bank
//
//  Created by Stepan Degtsiaryk on 5.02.26.
//

import SwiftUI

struct MyFinanceView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("My Finance")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .navigationTitle("My Finance")
        }
    }
}

#Preview {
    MyFinanceView()
}
