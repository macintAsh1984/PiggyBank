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
                // Display the user's account balance or $0.00 if no account has been created.
                if let balance = piggyBankUser.activeUser?.accounts.first?.balanceInUsd() ?? noBalance {
                    Text(String(format: "$%0.02f", balance))
                        .font(.custom(appFont, size: 40.0, relativeTo: .title))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                }
                /* Determine whether to display the appropriate method for displaying
                whether a user has an existing account.*/
                switch (noAccounts, displayEmptyTextView) {
                    case (true, _):
                    //If no accounts exist, regardless of displayEmptyTextView's value, display 'No accounts created'."
                        Text("No accounts created")
                            .font(.custom(appFont, size: 20.0, relativeTo: .title))
                            .fontWeight(.bold)
                    // If an account exists, display '$$$' to signify an existing account."
                    case (false, false):
                        Text("$$$")
                            .font(.custom(appFont, size: 20.0, relativeTo: .title))
                            .fontWeight(.bold)
                    // Show no text as a default option before determining if an account exists.
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
    
    /* Create a user and determine if that user has any active accounts to
     toggle the appropriate booleans that show the apprioriate text indicating account existence.*/
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
