//
//  AccountDetails.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 2/7/24.
//

import SwiftUI

struct AccountDetails: View {
    @State var showDepositSheet = false
    @State var showWithdrawSheet = false
    @State var showTransferSheet = false
    @EnvironmentObject var piggyBankUser: PiggyBankUser
    @State var index: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                let accountName = piggyBankUser.activeUser?.accounts[index].name ?? ""
                Text("Account: \(accountName)")
                    .font(.custom(appFont, size: 40.0, relativeTo: .title2))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                let accountPrice = piggyBankUser.activeUser?.accounts[index].balance ?? 0
                Text("$\(accountPrice)")
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
                            showDepositSheet.toggle()
                        } label: {
                            Label("Deposit", systemImage: "dollarsign.circle")
                        }
                        
                        Button() {
                            //action
                            showWithdrawSheet.toggle()
                        } label: {
                            Label("Withdraw", systemImage: "minus.circle")
                        }
                        
                        Button() {
                            //action
                            showTransferSheet.toggle()
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
            .sheet(isPresented: $showDepositSheet) {
                DepositSheet(index: index)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
                    .background(Color(appBackgroundColor))
            }
            .sheet(isPresented: $showWithdrawSheet) {
                WithdrawSheet(index: index)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
                    .background(Color(appBackgroundColor))
            }
            .sheet(isPresented: $showTransferSheet) {
                TransferSheet(index: index)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
                    .background(Color(appBackgroundColor))
            }

            
        }
    }
}

struct DepositSheet: View {
    @EnvironmentObject var piggyBankUser: PiggyBankUser
    @State var depositAmount = ""
    @State var index: Int

    var body: some View {
        TextField("Deposit Amount", text: $depositAmount)
            .frame(width: 300)
            .padding(.all)
            .background(.white)
            .cornerRadius(roundedCornerRadius)
        Spacer()
            .frame(height: 20)
        Button("Deposit") {
            //Button press action
            if let currAcc = piggyBankUser.activeUser?.accounts[index]{
                Task{
                    let apiResp = try await Api.shared.deposit(authToken: piggyBankUser.authToken ?? "", account: currAcc, amountInCents: Int(depositAmount) ?? 0)
                    
                    piggyBankUser.activeUser = apiResp.user

                }
            }
            
        }
            .font(.custom(appFont, size: 18.0))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.all)
            .background(Color(buttonBackgroundColor))
            .cornerRadius(roundedCornerRadius)
    }
}

struct WithdrawSheet: View {
    @State var withdrawAmount = ""
    @EnvironmentObject var piggyBankUser: PiggyBankUser
    @State var index: Int
    
    var body: some View {
        TextField("Withdraw Amount", text: $withdrawAmount)
            .frame(width: 300)
            .padding(.all)
            .background(.white)
            .cornerRadius(roundedCornerRadius)
        Spacer()
            .frame(height: 20)
        Button("Withdraw") {
            //Button press action
            if let currAcc = piggyBankUser.activeUser?.accounts[index]{
                Task{
                    let apiResp = try await Api.shared.withdraw(authToken: piggyBankUser.authToken ?? "", account: currAcc, amountInCents: Int(withdrawAmount) ?? 0)
                    
                    piggyBankUser.activeUser = apiResp.user

                }
            }
            
        }
            .font(.custom(appFont, size: 18.0))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.all)
            .background(Color(buttonBackgroundColor))
            .cornerRadius(roundedCornerRadius)
    }
}
struct TransferSheet: View {
    @State var transferAmount = ""
    @EnvironmentObject var piggyBankUser: PiggyBankUser
    @State var navigateToAccountDetails = false
    
    @State var index: Int //to keep track of the current index we are at so this will be the default transfer *FROM* account and we will be clicking for transfer *TO*
    
    var body: some View {
        Spacer()
            .frame(height: 20)
        TextField("Transfer Amount", text: $transferAmount)
            .frame(width: 300)
            .padding(.all)
            .background(.white)
            .cornerRadius(roundedCornerRadius)
        Spacer()
            .frame(height: 20)
        
        //Add UI for Sheet with accounts
        
        Form {
            Section {
                if let numAccounts = piggyBankUser.activeUser?.accounts.count {
                    ForEach(0..<numAccounts, id: \.self) { index in
                        let accountName = piggyBankUser.activeUser?.accounts[index].name ?? ""
                            Picker(accountName, selection: $navigateToAccountDetails) {
                                if let balance = piggyBankUser.activeUser?.accounts[index].balanceString() {
                                    Text("\(balance)").tag(index)

                                }
                            }
                            .pickerStyle(.navigationLink)
                    }
                }
            }
        }
        .background(Color(appBackgroundColor))
        .scrollContentBackground(.hidden)
    }
}



//#Preview {
//    AccountDetails()
//}
