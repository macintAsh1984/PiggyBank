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
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("PiggyBank Icon")
                Text("Total Assets")
                    .font(.custom(appFont, size: 25.0, relativeTo: .title2))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                Text("$0.00")
                    .font(.custom(appFont, size: 40.0, relativeTo: .title))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
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
}

//#Preview {
//    HomePageView()
//        .environmentObject(PiggyBankUser)
//}
