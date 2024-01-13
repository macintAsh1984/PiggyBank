//
//  ContentView.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("PiggyBank Icon")
                .resizable()
                .frame(width: 477.0, height: 332.0)
            Spacer()
            Text("PiggyBank")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(Color(hue: 324.0, saturation: 0.15, brightness: 0.97))
    }
}

#Preview {
    ContentView()
}
