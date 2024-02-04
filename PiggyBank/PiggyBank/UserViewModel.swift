//
//  UserViewModel.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/29/24.
//

import SwiftUI

class PiggyBankUser: ObservableObject {
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var authToken: String?
    @Published var accounts: [Account] = [Account]()
    
    
    let noAuthTokenError = ApiError(errorCode: "no_auth_token_error", message: "No auth token has been set for this user")
    let setAuthTokenError = ApiError(errorCode: "set_auth_token_error", message: "Failed to set user auth token")
    let setUserNameError = ApiError(errorCode: "set_user_name_error", message: "Failed to set username")
    
    func saveAuthToken(e164phoneNumber: String, code: String) async throws {
        guard let checkVerificationResponse = try? await Api.shared.checkVerificationToken(e164PhoneNumber: e164phoneNumber, code: code) else { throw setAuthTokenError }
        UserDefaults.standard.setValue(checkVerificationResponse.authToken, forKey: "authToken")
    }
    
    func setUserName(username: String) {
        self.name = username
    }
    
    func setPhoneNumber(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        UserDefaults.standard.setValue(self.phoneNumber, forKey: "phoneNumber")
    }
    
    func getPhoneNumber() -> String {
        return self.phoneNumber
    }
    
    func saveUserName(name: String, authToken: String) async throws {
        guard let username = try? await Api.shared.setUserName(authToken: authToken, name: name) else { throw setUserNameError }
        UserDefaults.standard.setValue(username.user.name, forKey: "name")
    }
    
    func loadUserName() {
        if let username =  UserDefaults.standard.string(forKey: "name") {
            self.name = username
        } else {
            print("hi")
        }
    }
    
    func loadPhoneNumber() {
        if let phoneNumber =  UserDefaults.standard.string(forKey: "phoneNumber") {
            self.phoneNumber = phoneNumber
        } else {
            print("hi")
        }
    }
    

    func loadUser() {
        if let authToken =  UserDefaults.standard.string(forKey: "authToken") {
            self.authToken = authToken
        } else {
            print("hi")
        }
        
    }
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        self.name = String()
        self.phoneNumber = String()
        self.authToken = nil
        self.accounts = [Account]()
    }
    
}
