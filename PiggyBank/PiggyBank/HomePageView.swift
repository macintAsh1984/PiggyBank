//
//  HomePageView.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/23/24.
//

import SwiftUI

struct HomePageView: View {
    @State var noAccounts = false
    @State var displayEmptyTextView = true
    @EnvironmentObject var piggyBankUser: PiggyBankUser
    let noBalance: Double? = 0.00
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("PiggyBank Icon")
                Text("Total Assets")
                    .font(.custom(appFont, size: 25.0, relativeTo: .title2))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                if let balance = piggyBankUser.activeUser?.accounts.first?.balanceInUsd() ?? noBalance {
                    Text(String(format: "$%0.02f", balance))
                        .font(.custom(appFont, size: 40.0, relativeTo: .title))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                }
                switch (noAccounts, displayEmptyTextView) {
                    case (true, _):
                        Text("No accounts created")
                            .font(.custom(appFont, size: 20.0, relativeTo: .title))
                            .fontWeight(.bold)
                    case (false, false):
                        Text("$$$")
                            .font(.custom(appFont, size: 20.0, relativeTo: .title))
                            .fontWeight(.bold)
                    case (false, true):
                        Text("")
                }
            }
            .onAppear {
                displayAccountExistence()
            }
            .navigationTitle("Piggybanks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(buttonBackgroundColor), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light)
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        AccountSettings()
                            .environmentObject(piggyBankUser)
                        
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
            .preferredColorScheme(.light)
            .background(Color(appBackgroundColor))
            .navigationBarBackButtonHidden(true)
        }

    }
    
    func displayAccountExistence() {
        Task {
            if let authToken = piggyBankUser.authToken {
                try await piggyBankUser.createUser(authToken: authToken)
                if let user = piggyBankUser.activeUser {
                    if user.accounts.isEmpty {
                        noAccounts = true
                    } else {
                        noAccounts = false
                        displayEmptyTextView = false
                    }
                }
            }
        }
    }
}
