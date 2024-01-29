//
//  VerificationView.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/20/24.
//

import SwiftUI

let backSpace: String = "\u{200B}"
let numOfOTPFields = 6

struct VerificationView: View {
    /* An array that stores the digits a user types in for the verification code.
     Fill the array with the backspace zero-width character to account for deletion.*/
    @State var enteredDigits = [String](repeating: backSpace, count: numOfOTPFields)
    @FocusState var isFocusedOnField: Int?
    @State var showHomeView = false
    @State var invalidCodeAlert = false
    @State var isLoading = false
    
    
    var body: some View {
        VStack {
            // While the API is checking if the entered code is correct, show a loading icon to show the user the API is processing the code.
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .controlSize(.large)
            }
            VerifyYourCodeTextView()
            HStack {
                //Create 6 textfields for the 6 digit verification code.
                ForEach(0..<numOfOTPFields, id: \.self) { index in
                    OTPTextField(enteredDigits: $enteredDigits, isFocusedOnField: $isFocusedOnField, index: index)
                        .allowsHitTesting(isFocusedOnField == index)
                        .onChange(of: enteredDigits[index]) {
                            /* When a textfield has the backspace character + the entered digit
                            and the index is less than five, move to the next textfield.*/
                            if enteredDigits[index].count == 2 && index < numOfOTPFields - 1 {
                                isFocusedOnField = (isFocusedOnField ?? 0) + 1
                              
                            /* Otherwise if the textfield if empty and the index is not the first index of the array,
                                before deletion, add the backspace character, delete the digit, and move back one textfield.*/
                            } else if enteredDigits[index].isEmpty && index > 0 {
                                enteredDigits[index] = backSpace
                                isFocusedOnField = (isFocusedOnField ?? 0) - 1
                            }
                            
                            /* When the cursor is on the last textfield and the count for the textfield is 2
                            (which contains the backspace character + the entered digit), verify the code the user entered.*/
                            if index == numOfOTPFields - 1 && enteredDigits[index].count == 2 {
                                verifyOTPcode()
                            }
                    }
                        .onAppear {
                            if index == 0 {
                                isFocusedOnField = index
                            }
                        }
                }
            }
            .navigationDestination(isPresented: $showHomeView) {
                HomePageView()
            }
            .alert("Invalid Code", isPresented: $invalidCodeAlert) {
                Button("OK") { }
            }
            Spacer()
                .frame(height: 20)
            ResendVerificationButtonView()
        }
        .padding()
        //Cover the entire background with the custom color appBackgroundColor
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
        .background(Color(appBackgroundColor))
        //Set the app's color scheme to light mode as default to prevent black text from turning white when a user enables dark mode.
        .preferredColorScheme(.light)
    }
    
    func verifyOTPcode() {
        /* Take the array of entered digits and remove the backspace character separating the digits.
        Then, begin loading to signify the code verification checking is processing.*/
        let code = enteredDigits.joined().filter {$0 != "\u{200B}"}
        isFocusedOnField = nil
        isLoading = true
        
        /* If the code verification verfied the code the user entered, navigate to the home screen.
        If code verification couldn't verify the code, show an alert and erase what is currently in the textfields.*/
        Task {
            do {
                let _ = try await Api.shared.checkVerificationToken(e164PhoneNumber: e164PhoneNumber, code: code)
                showHomeView = true
                isLoading = false
            } catch  {
                invalidCodeAlert = true
                isLoading = false
                enteredDigits = [String](repeating: backSpace, count: numOfOTPFields)
            }
        }
    }

}

#Preview {
    VerificationView()
}

struct VerifyYourCodeTextView : View {
    var body: some View {
        Spacer()
            .frame(height: 20)
        Text("Verify Your Code")
            .font(.custom(appFont, size: 40.0, relativeTo: .title))
            .fontWeight(.bold)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
        Spacer()
            .frame(height: 20)
        Text("Enter the code sent to your phone number")
            .font(.custom(appFont, size: 22.0, relativeTo: .title2))
            .fontWeight(.medium)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
        Spacer()
            .frame(height: 20)
    }
}

struct OTPTextField: View {
    @Binding var enteredDigits : [String]
    @FocusState.Binding var isFocusedOnField: Int?
    var index: Int
    
    var body : some View {
        TextField("", text: $enteredDigits[index])
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .multilineTextAlignment(.center)
            .padding(.all)
            .background(.white)
            .cornerRadius(roundedCornerRadius)
            .focused($isFocusedOnField, equals: index)
            .tag(index)
    }
}

struct ResendVerificationButtonView: View {
    var body: some View {
        Button("Resend Verification Code") {
            Task {
                do {
                    let _ = try await Api.shared.sendVerificationToken(e164PhoneNumber: e164PhoneNumber)
                } catch let apiError as ApiError {
                    let _ = apiError.message
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
