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
    
    @State var accountPrice: Double = 0.00
    @EnvironmentObject var piggyBankUser: PiggyBankUser
    @State var index: Int
    @State var accountName: Account?
    @State var navigatetoHome = false
    @State var showdeletealert = false
    
    
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                let name = piggyBankUser.activeUser?.accounts[index].name ?? ""
                Text("Account: \(name)")
                    .font(.custom(appFont, size: 40.0, relativeTo: .title2))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                //accountPrice = piggyBankUser.activeUser?.accounts[index].balance ?? 0
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
                            //accountPrice = accountPrice
                        } label: {
                            Label("Transfer", systemImage: "arrowshape.turn.up.right")
                        }
                        
                        Divider()
                        
                        
                       

                        
                        Button(role: .destructive) {
                            if let account = accountName {
                                Task {
                                    do {
                                        try await piggyBankUser.DeleteAccount(accountName: account)
                                        navigatetoHome = true
                                        
                                    } catch {
                                        print ("Error deleting")
                                    }
                                }
                            } else {
                                print("Error: Account is nil")
                            }
                            
                            
                            
                           
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
                DepositSheet()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
                    .background(Color(appBackgroundColor))
            }
            .sheet(isPresented: $showWithdrawSheet) {
                WithdrawSheet()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
                    .background(Color(appBackgroundColor))
            }
            .sheet(isPresented: $showTransferSheet) {
                TransferSheet(currentIndexofthecurrentuser: index, theamounttopass: accountPrice)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
                    .background(Color(appBackgroundColor))
                
            }
            .navigationDestination(isPresented: $navigatetoHome) {
                HomePageView()
                    .environmentObject(piggyBankUser)
            }
            
            
            
            
            
            
            
            .onAppear {
                accountPrice = piggyBankUser.activeUser?.accounts[index].balanceInUsd() ?? 0

                Task {
                    do {
                        let bro = try await Api.shared.user(authToken: piggyBankUser.authToken ?? "").user.accounts[index]
                        accountName = bro
                    }catch {
                        print("error retreiving account")
                    }
                    
                }
                 
                
                
                
            }
        }
    }
    
    struct DepositSheet: View {
        @State var depositAmount = ""
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
        @State var transferAmount: Double = 0.00
        @State var selectedAccountIndex: Int?
        @State var currentIndexofthecurrentuser: Int
        @EnvironmentObject var piggyBankUser: PiggyBankUser
        @State var navigateToAccountDetails = false
        @State var theamounttopass: Double
        @State var thealertforinvalid = false
        @State var pleaseselectaccount = false
        
        var body: some View {
            Spacer()
                .frame(height: 20)
            TextField("Transfer Amount", value: $transferAmount, formatter: NumberFormatter())
                .frame(width: 300)
                .padding(.all)
                .background(.white)
                .cornerRadius(roundedCornerRadius)
            
            Spacer()
                .frame(height: 20)
            
            Text("Variable passed: \(theamounttopass)")
            
            //Add UI for Sheet with accounts
            
            Button("Transfer") {
                //Button press action
                guard let theacount = selectedAccountIndex else {
                    thealertforinvalid = true
                    return}
                
                guard let theselectedaccount = piggyBankUser.activeUser?.accounts[theacount] else {
                    print("not a valid account")
                    return
                }
                
                
                
                if transferAmount <= 0 {
                    thealertforinvalid = true
                } else {
                    Task {
                        do {
                            piggyBankUser.loadUserAuthToken()
                            guard let originalAccount = piggyBankUser.activeUser?.accounts[currentIndexofthecurrentuser] else {
                                print("No original account exists")
                                return
                            }
                            try await Api.shared.transfer(authToken: piggyBankUser.authToken ?? "", from: originalAccount, to: theselectedaccount, amountInCents: Int(transferAmount * 100))
                        }
                    }
                }
                
                if transferAmount > theamounttopass {
                    thealertforinvalid = true
                }

            }
            .font(.custom(appFont, size: 18.0))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.all)
            .background(Color(buttonBackgroundColor))
            .cornerRadius(roundedCornerRadius)
            
            
            
            Form {
                    Section {
                            if let numAccounts = piggyBankUser.activeUser?.accounts.count {
                                ForEach(0..<numAccounts, id: \.self) { index in
                                    let accountName = piggyBankUser.activeUser?.accounts[index].name ?? ""
                                    Button(action: {
                                        selectedAccountIndex = index
                                    }) {
                                        HStack {
                                            Text(accountName)
                                            Spacer()
                                            if let balance = piggyBankUser.activeUser?.accounts[index].balanceString() {
                                                Text("\(balance)")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                    .foregroundColor(selectedAccountIndex == index ? .blue : .black)
                                    .background(selectedAccountIndex == index ? Color.blue.opacity(0.2) : Color.clear)
                                }
                            }
                        }
                }

            .background(Color(appBackgroundColor))
            .scrollContentBackground(.hidden)

            .alert(isPresented: $thealertforinvalid) {
                Alert(
                    title: Text("Error"),
                    message: Text("Transfer amount cannot exceed the available amount, it also cannot be negative, also make sure to choose an account"),
                    dismissButton: .default(Text("OK"))
                )
            }

        }
    }
    
    
    
    
    
   
}
