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
        switch piggyBankUser.authToken {
        case nil:
            SplashScreen()
                .environmentObject(piggyBankUser)
        default:
            //Replace with loading screen later
            HomePageView()
                .environmentObject(piggyBankUser)
        }
    }
}

//#Preview {
//    RootView()
//}
