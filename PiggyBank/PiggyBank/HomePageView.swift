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
    @State var navigateToProfileSettings = false
    @State var navigateToAccountDetails = false
    @State var addAccountSheet = false
    @EnvironmentObject var piggyBankUser: PiggyBankUser
    let noBalance: Double? = 0.00
    @State var totalAssets: Double = 0.00
    
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
                Text(String(totalAssets) + "0")
                    .font(.custom(appFont, size: 40.0, relativeTo: .title))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                Form {
                    Section {
                        if let numAccounts = piggyBankUser.activeUser?.accounts.count {
                            ForEach(0..<numAccounts, id: \.self) { index in
                                let accountName = piggyBankUser.activeUser?.accounts[index].name ?? ""
                                //let balanceString = piggyBankUser.activeUser?.accounts[index].balanceString() ?? ""
                                NavigationLink(destination: AccountDetails(index: index)) {
                                    Text(accountName)
                                }
                            }
                        }
                    }
                }
                .background(Color(appBackgroundColor))
                .scrollContentBackground(.hidden)
            }
            .onAppear {
                totalAssets = piggyBankUser.calculateTotalAssets()
                displayAccountExistence()
            }
            .navigationTitle("Piggybanks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(buttonBackgroundColor), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light)
            .toolbar {
                ToolbarItem {
                    Menu() {
                        Button(action: {
                            // Bring up sheet to add new account.
                            addAccountSheet.toggle()
                        }) {
                            Label("Add Account", systemImage: "plus")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Go to the Profile Settings on click.
                            navigateToProfileSettings.toggle()
                        }) {
                            Label("Profile Settings", systemImage: "person.crop.circle.fill")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
            .preferredColorScheme(.light)
            .background(Color(appBackgroundColor))
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $addAccountSheet) {
                AddAccountSheet(addAccountSheet: $addAccountSheet)
                    .environmentObject(piggyBankUser)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
                    .background(Color(appBackgroundColor))
            }
            .navigationDestination(isPresented: $navigateToProfileSettings) {
                AccountSettings()
                    .environmentObject(piggyBankUser)
            }
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

struct AddAccountSheet: View {
    @State var accountName = ""
    @Binding var addAccountSheet: Bool
    @EnvironmentObject var piggyBankUser: PiggyBankUser
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        TextField("Account Name", text: $accountName)
            .frame(width: 375)
            .padding(.all)
            .background(.white)
            .cornerRadius(roundedCornerRadius)
        Spacer()
            .frame(height: 20)
        Button("Create Account") {
            Task {
                try await piggyBankUser.createNewAccount(accountName:accountName)
            }
            dismiss()
        }
            .font(.custom(appFont, size: 18.0))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.all)
            .background(Color(buttonBackgroundColor))
            .cornerRadius(roundedCornerRadius)
    }
}

