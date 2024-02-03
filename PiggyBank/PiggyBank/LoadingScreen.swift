//
//  LoadingScreen.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/31/24.
//

import SwiftUI

struct LoadingScreen: View {
    @State var canLoadHomePage: Bool = false
    var body: some View {
        VStack {
            if canLoadHomePage {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .controlSize(.large)
            }
            Text("Loading")
        }
        .padding()
        //Cover the entire background with the custom color appBackgroundColor
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
        .background(Color(appBackgroundColor))
        //Set the app's color scheme to light mode as default to prevent black text from turning white when a user enables dark mode.
        .preferredColorScheme(.light)
    }
}

#Preview {
    LoadingScreen()
}
