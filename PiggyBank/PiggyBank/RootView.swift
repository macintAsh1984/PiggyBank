//
//  RootView.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 2/2/24.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var piggyBankUser: PiggyBankUser
    var body: some View {
        /* To determine which screen to show upon app launch, check to see if an authentication token exists.
         If yes, show a loading screen that takes the user to PiggyBank's home page. Otherwise, show the splash screen
         and have the user go through the log in process.*/
        switch piggyBankUser.authToken {
        case nil:
            SplashScreen()
                .environmentObject(piggyBankUser)
        default:
                LoadingScreen()
                    .environmentObject(piggyBankUser)
        }
    }
}
