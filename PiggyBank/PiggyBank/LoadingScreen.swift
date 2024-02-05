//
//  LoadingScreen.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/31/24.
//

import SwiftUI

struct LoadingScreen: View {
    @State var loadingHomePage = false
    @State var goToHomePage = false
    @EnvironmentObject var piggyBankUser: PiggyBankUser
    
    var body: some View {
        NavigationStack {
            VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                if loadingHomePage {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(4)
                }
            }
            .onAppear {
                piggyBankUser.loadAuthTokenTime()
                loadingHomePage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + piggyBankUser.authTokenTime) {
                    loadingHomePage = false
                    goToHomePage = true
                }
            }
            .navigationDestination(isPresented: $goToHomePage) {
                HomePageView()
                    .environmentObject(piggyBankUser)
            }
            .padding()
            //Cover the entire background with the custom color appBackgroundColor
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
            .background(Color(appBackgroundColor))
            //Set the app's color scheme to light mode as default to prevent black text from turning white when a user enables dark mode.
            .preferredColorScheme(.light)
        }
    }
    
}

#Preview {
    LoadingScreen()
        .environmentObject(PiggyBankUser())
}
