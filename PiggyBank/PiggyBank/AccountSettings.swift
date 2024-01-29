//
//  AccountSettings.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/28/24.
//

import SwiftUI

struct AccountSettings: View {
    @State var username: String = ""
    @State var phoneNumber: String = e164PhoneNumber
    var body: some View {
        NavigationStack {
            VStack {
                UserInfoView(username: $username, phoneNumber: $phoneNumber)
                Spacer()
                    .frame(height: 20)
                LogoutButtonView()
                Spacer()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(buttonBackgroundColor), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light)
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        //Save username
                    } label: {
                        Text("Save")
                    }
                }
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
    AccountSettings()
}

struct UserInfoView: View {
    @Binding var username: String
    @Binding var phoneNumber: String
    
    var body: some View {
        TextField("Username", text: $username)
            .padding(.all)
            .background(.white)
            .cornerRadius(roundedCornerRadius)
        TextField("", text: $phoneNumber)
            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding(.all)
            .background(.white)
            .cornerRadius(roundedCornerRadius)
    }
}

struct LogoutButtonView: View {
    var body: some View {
        Button("Logout") {
            // Logout of account.
        }
        .font(.custom(appFont, size: 18.0))
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .padding(.all)
        .background(Color(buttonBackgroundColor))
        .cornerRadius(roundedCornerRadius)
    }
}
