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
    
    //Contains the user that is currently logged in
    @Published var activeUser: User?
    
    //Stores the time it takes to create the authentication token.
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
    
    // Functions For Authentication Token Logic
    func saveAuthToken(e164phoneNumber: String, code: String) async throws {
        guard let checkVerificationResponse = try? await Api.shared.checkVerificationToken(e164PhoneNumber: e164phoneNumber, code: code) 
        else { throw createAuthTokenError }
        UserDefaults.standard.setValue(checkVerificationResponse.authToken, forKey: "authToken")
    }
    
    func recordAuthTokenTime() async throws {
        // Start recording the time it takes to create the authentication token.
        let startTime = Date()
        Task {
            do {
                // Create an authentication token for a new user.
                guard let _ = try? await Api.shared.checkVerificationToken(e164PhoneNumber: self.phoneNumber, code: self.verificationCode)
                else { throw createAuthTokenError }
            } catch {
                throw unknownError
            }
            
            // Stop recording the time, determine the total time, and store it in disk to use for the loading screen.
            let stopTime = Date()
            let totalTime = stopTime.timeIntervalSince(startTime)
            UserDefaults.standard.setValue(totalTime, forKey: "totalTime")
        }
    }
    
    // Functions Related To User and Username Logic
    func createUser(authToken: String) async throws {
        do {
            /* Make an API to retrieve a UserResponse that contains the user and store it
             in the activeUser attribute of this view model.*/
            let userResponse = try await Api.shared.user(authToken: authToken)
            self.activeUser = userResponse.user
        } catch {
            throw createUserError
        }
    }
    
    func saveNewUserName(name: String, authToken: String) async throws {
        /* Make an API call and set the name attribute of this view model
        with the new username a user enters in Settings.*/
        guard let username = try? await Api.shared.setUserName(authToken: authToken, name: name)
        else { throw setUserNameError }
        self.name = username.user.name ?? name
        UserDefaults.standard.setValue(username.user.name, forKey: "name")
    }
    
    
    //Functions Related To Loading Account Information From Disk
    func loadUserName() {
        /* Determine if a user with an account already has an existing username
        and set the name attribute of this view model to that existing username.
        If no existing username is on file, then set the name attribute to what they enter in Settings.*/
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
        /* Retrieve the phone number from disk and set the phoneNumber attribute
         of this view model to that phone number.*/
        if let phoneNumber =  UserDefaults.standard.string(forKey: "phoneNumber") {
            self.phoneNumber = phoneNumber
        } else {
            print(fetchPhoneNumberError.message)
        }
    }

    func loadUserAuthToken() {
        /* Retrieve the authentication token from disk and set the authToken attribute
         of this view model to that token.*/
        if let authToken =  UserDefaults.standard.string(forKey: "authToken") {
            self.authToken = authToken
        } else {
            print(setAuthTokenError.message)
        }
        
    }
    
    func loadAuthTokenTimeFromDisk() {
        /* Store the record time it takes to generate an authentication token to disk and
         assign its value to the authTokenTime attribute of this view model.*/
        let authTokenTime = UserDefaults.standard.double(forKey: "totalTime")
        self.authTokenTime = authTokenTime
    }
    
    // Function That Related To User Logout
    func logOut() {
        /* Remove the user's authentication token, username, and phoneNumber
        from disk and set all view model attributes to empty strings or nil.*/
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        self.name = String()
        self.phoneNumber = String()
        self.authToken = nil
        self.activeUser = nil
    }
    
}
