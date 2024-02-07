//
//  AccountDetails.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 2/7/24.
//

import SwiftUI

struct AccountDetails: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Account Name")
                    .font(.custom(appFont, size: 40.0, relativeTo: .title2))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                Text("$Money Amount Goes Here")
                    .font(.custom(appFont, size: 25.0, relativeTo: .title2))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
            .navigationTitle("Account Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(buttonBackgroundColor), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light)
            .toolbar {
                ToolbarItem {
                    Menu() {
                        Button() {
                            //action
                        } label: {
                            Label("Deposit", systemImage: "dollarsign.circle")
                        }
                        
                        Button() {
                            //action
                        } label: {
                            Label("Withdraw", systemImage: "minus.circle")
                        }
                        
                        Button() {
                            //action
                        } label: {
                            Label("Transfer", systemImage: "arrowshape.turn.up.right")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                        } label: {
                            Label("Delete Account", systemImage: "trash")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
            .preferredColorScheme(.light)
            .background(Color(appBackgroundColor))
            
        }
    }
}

#Preview {
    AccountDetails()
}
