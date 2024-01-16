//
//  SplashScreen.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/16/24.
//

import SwiftUI

struct SplashScreen: View {
    @State var splashScreenIsActive = false
    
    var body: some View {
        if splashScreenIsActive {
            ContentView()
        } else {
            VStack {
                VStack {
                    Image("PiggyBank Icon")
                    Text("PiggyBank")
                        .font(.custom(appFont, size: 50.0, relativeTo: .title))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
            .background(Color(appBackgroundColor))
            .preferredColorScheme(.light)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.splashScreenIsActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
