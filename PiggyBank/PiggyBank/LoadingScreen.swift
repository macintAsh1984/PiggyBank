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
                // Show a loading icon to indicate Home page loading when possible.
                if loadingHomePage {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(4)
                }
            }
            .onAppear {
                loadHomePage()
            }
            .navigationDestination(isPresented: $goToHomePage) {
                HomePageView()
                    .environmentObject(piggyBankUser)
            }
            .padding()
            // Cover the entire background with the custom color appBackgroundColor
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
            .background(Color(appBackgroundColor))
            // Set the app's color scheme to light mode as default to prevent black text from turning white when a user enables dark mode.
            .preferredColorScheme(.light)
        }
    }
    
    /* To load the Home Page, fetch the authentication token from disk
     and show the loading screen for the amount of time it takes to generate an authentication token.*/
    func loadHomePage() {
        piggyBankUser.loadAuthTokenTimeFromDisk()
        loadingHomePage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + piggyBankUser.authTokenTime) {
            loadingHomePage = false
            goToHomePage = true
        }
    }
    
}
