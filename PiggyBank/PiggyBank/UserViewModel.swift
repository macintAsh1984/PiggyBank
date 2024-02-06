//
//  UserViewModel.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/29/24.
//

import SwiftUI

@MainActor class PiggyBankUser: ObservableObject {
    @Published var name: String = String()
    @Published var phoneNumber: String = String()
    @Published var authToken: String?
    
    @Published var activeUser: User?
    
    @Published var authTokenTime: TimeInterval = 0
    @Published var verificationCode: String = String()
    
    //Error Handling Messages
    let noAuthTokenError = ApiError(errorCode: "no_auth_token_error", message: "No auth token has been set for this user")
    let setAuthTokenError = ApiError(errorCode: "set_auth_token_error", message: "Failed to set user auth token")
    let createAuthTokenError = ApiError(errorCode: "create_auth_token_error", message: "Failed to create user auth token")
    
    let createUserError = ApiError(errorCode: "find_user_error", message: "Could not create user")
    let setUserNameError = ApiError(errorCode: "set_user_name_error", message: "Failed to set username")
    let loadUserNameError = ApiError(errorCode: "load_user_name_error", message: "Could not load username")
    
    let fetchPhoneNumberError = ApiError(errorCode: "fetch_phone_number_error", message: "Could not fetch phone number from disk")
    let unknownError = ApiError(errorCode: "unknown_error", message: "An unexpected error occured")
    
    // Setter Functions
    func setVerificationCode(_ to: String) {
        self.verificationCode = to
    }
    
    func setPhoneNumber(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        UserDefaults.standard.setValue(self.phoneNumber, forKey: "phoneNumber")
    }
    
    //Functions For Authentication Token Logic
    func saveAuthToken(e164phoneNumber: String, code: String) async throws {
        guard let checkVerificationResponse = try? await Api.shared.checkVerificationToken(e164PhoneNumber: e164phoneNumber, code: code) 
        else { throw createAuthTokenError }
        UserDefaults.standard.setValue(checkVerificationResponse.authToken, forKey: "authToken")
    }
    
    func recordAuthTokenTime() async throws {
        let startTime = Date()
        Task {
            do {
                guard let _ = try? await Api.shared.checkVerificationToken(e164PhoneNumber: self.phoneNumber, code: self.verificationCode) 
                else { throw createAuthTokenError }
            } catch {
                throw unknownError
            }
            
            let stopTime = Date()
            let totalTime = stopTime.timeIntervalSince(startTime)
            UserDefaults.standard.setValue(totalTime, forKey: "totalTime")
        }
    }
    
    // Functions Related To User and Username Logic
    func createUser(authToken: String) async throws {
        do {
            let userResponse = try await Api.shared.user(authToken: authToken)
            self.activeUser = userResponse.user
        } catch {
            throw createUserError
        }
    }
    
    func saveNewUserName(name: String, authToken: String) async throws {
        guard let username = try? await Api.shared.setUserName(authToken: authToken, name: name)
        else { throw setUserNameError }
        self.name = username.user.name ?? name
        UserDefaults.standard.setValue(username.user.name, forKey: "name")
    }
    
    
    //Functions Related To Loading Account Information From Disk
    func loadUserName() {
        if let existingUserName = self.activeUser?.accounts.first?.name {
            if !existingUserName.isEmpty {
                self.name = existingUserName
            }
        } else {
            self.name = UserDefaults.standard.string(forKey: "name") ?? ""
            print(loadUserNameError.message)
        }
    }
    
    func loadPhoneNumber() {
        if let phoneNumber =  UserDefaults.standard.string(forKey: "phoneNumber") {
            self.phoneNumber = phoneNumber
        } else {
            print(fetchPhoneNumberError.message)
        }
    }

    func loadUserAuthToken() {
        if let authToken =  UserDefaults.standard.string(forKey: "authToken") {
            self.authToken = authToken
        } else {
            print(setAuthTokenError.message)
        }
        
    }
    
    func loadAuthTokenTimeFromDisk() {
        let authTokenTime = UserDefaults.standard.double(forKey: "totalTime")
        self.authTokenTime = authTokenTime
    }
    
    // Function That Related To User Logout
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        self.name = String()
        self.phoneNumber = String()
        self.authToken = nil
        self.activeUser = nil
    }
    
}
