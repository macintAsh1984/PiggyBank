//
//  AccountSettings.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/28/24.
//

import SwiftUI

struct AccountSettings: View {
    @State var username: String = ""
    @FocusState var keyboardFocus: Bool
    @EnvironmentObject var piggyBankUser: PiggyBankUser
        
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Username", text: $piggyBankUser.name)
                    .padding(.all)
                    .focused($keyboardFocus)
                    .background(.white)
                    .cornerRadius(roundedCornerRadius)
                TextField("", text: $piggyBankUser.phoneNumber)
                    .padding(.all)
                    .focused($keyboardFocus)
                    .background(.white)
                    .cornerRadius(roundedCornerRadius)
                Spacer()
                    .frame(height: 20)
                LogoutButtonView()
                    .environmentObject(piggyBankUser)
                Spacer()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(buttonBackgroundColor), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light)
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        Task {
                            guard let authToken = piggyBankUser.authToken else {throw piggyBankUser.noAuthTokenError}
                            try await piggyBankUser.saveUserName(name: piggyBankUser.name, authToken: authToken)
                        }
                    }
                }
            }
            .padding()
            //Cover the entire background with the custom color appBackgroundColor
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
            .background(Color(appBackgroundColor))
            //Set the app's color scheme to light mode as default to prevent black text from turning white when a user enables dark mode.
            .preferredColorScheme(.light)
            .onTapGesture {
                keyboardFocus = false
            }
            .onAppear {
                piggyBankUser.loadUserName()
                piggyBankUser.loadPhoneNumber()
            }
        }
    }
}

//#Preview {
//    AccountSettings()
//}


struct LogoutButtonView: View {
    var body: some View {
        Button("Logout") {
            // Logout of account.
            //Drop keyboard focus
        }
        .font(.custom(appFont, size: 18.0))
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .padding(.all)
        .background(Color(buttonBackgroundColor))
        .cornerRadius(roundedCornerRadius)
    }
}
