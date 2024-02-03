//
//  SplashScreen.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/16/24.
//

import SwiftUI

struct SplashScreen: View {
    @State var splashScreenIsActive = false
    @State var showHomeView = false
    @EnvironmentObject var piggyBankUser: PiggyBankUser
    
    var body: some View {
        //To prevent the splash screen from being stuck on the screen, show the main app view when the toggle, splashScreenIsActive is true.
        if splashScreenIsActive {
            LoginView()
                .environmentObject(piggyBankUser)
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
                Task {
                    do {
                        piggyBankUser.loadUser()
                        showHomeView = true
                    } catch {
                        showHomeView = false
                    }
                }
                //The splashscreen will stay onscreen for 2 seconds.
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
