//
//  PiggyBankApp.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/12/24.
//

import SwiftUI

@main
struct PiggyBankApp: App {
    @StateObject var piggyBankUser = PiggyBankUser()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(piggyBankUser)
        }
    }
}
