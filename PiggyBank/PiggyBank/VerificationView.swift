//
//  VerificationView.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/20/24.
//

import SwiftUI

struct VerificationView: View {
    @State var enteredDigits = [String](repeating: "", count: 6)
    @FocusState var isFocusedOnField: Int?
    @State var showHomeView = false
    @State var invalidCodeAlert = false
    
    
    var body: some View {
        VStack {
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
            HStack {
                ForEach(0..<6, id: \.self) { index in
                    TextField("", text: $enteredDigits[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .padding(.all)
                        .background(.white)
                        .cornerRadius(roundedCornerRadius)
                        .focused($isFocusedOnField, equals: index)
                        .tag(index)
                        .onChange(of: enteredDigits[index]) { oldValue, newValue in
                            if !newValue.isEmpty {
                                isFocusedOnField = (isFocusedOnField ?? 0) + 1
                                
                            } else {
                                isFocusedOnField = (isFocusedOnField ?? 0) - 1
                            }
                            
                            if enteredDigits[index].count > 1 {
                                if enteredDigits[index].prefix(1) == oldValue {
                                    enteredDigits[index] = String(enteredDigits[index].dropFirst())
                                } else {
                                    enteredDigits[index] = String(enteredDigits[index].dropLast())
                                }
                            }
                            let code = enteredDigits.joined()
                            if code.count == 6 {
                                isFocusedOnField = nil
                                Task {
                                    do {
                                        let _ = try await Api.shared.checkVerificationToken(e164PhoneNumber: e164PhoneNumber, code: code)
                                        showHomeView = true
                                    } catch  {
                                        invalidCodeAlert = true
                                    }
                                }

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
        .padding()
        //Cover the entire background with the custom color appBackgroundColor
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
        .background(Color(appBackgroundColor))
        //Set the app's color scheme to light mode as default to prevent black text from turning white when a user enables dark mode.
        .preferredColorScheme(.light)
    }
}

#Preview {
    VerificationView()
}
