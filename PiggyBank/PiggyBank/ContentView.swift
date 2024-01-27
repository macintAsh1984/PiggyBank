//
//  ContentView.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/12/24.
//

import SwiftUI
import PhoneNumberKit

let phoneNumberKit = PhoneNumberKit()

// Fonts and Color names
let appBackgroundColor = "Light Pink"
let buttonBackgroundColor = "Dark Pink"
let appFont = "CandyBeans"
let roundedCornerRadius = 10.0

let countryCodes = ["🇺🇸 US +1"]
var e164PhoneNumber: String = ""

struct ContentView: View {
    @State var phoneNumber: String = ""
    @State var countryCodeCount: Int = 0
    @State var invalidNumberAlert = false
    @State var showVerificationView = false
    @FocusState var numberIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Image("PiggyBank Icon")
                Text("PiggyBank")
                    .font(.custom(appFont, size: 50.0, relativeTo: .title))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
                    .frame(height: 20)
                Text("Enter your mobile phone number")
                    .font(.custom(appFont, size: 22.0, relativeTo: .title2))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                Spacer()
                    .frame(height: 20)
                HStack {
                    PhoneNumberEntryView(countryCodeCount: $countryCodeCount, phoneNumber: $phoneNumber, numberIsFocused: $numberIsFocused)
                }
                Spacer()
                    .frame(height: 30)
                VerificationButtonView(phoneNumber: $phoneNumber, numberIsFocused: $numberIsFocused, invalidNumberAlert: $invalidNumberAlert, showVerificationView: $showVerificationView)
                Spacer()
            }
            .padding()
        //Cover the entire background with the custom color appBackgroundColor
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
            .background(Color(appBackgroundColor))
        
        //Set the app's color scheme to light mode as default to prevent black text from turning white when a user enables dark mode.
            .preferredColorScheme(.light)
        
        //When the user taps outside the textfield, the numberkey pad is dismissed.
            .onTapGesture {
                numberIsFocused = false
            }
        }
        
       }
    }


struct PhoneNumberEntryView: View {
    @Binding var countryCodeCount: Int
    @Binding var phoneNumber: String
    @FocusState.Binding var numberIsFocused: Bool
    
    let phoneNumberplaceholder = "(555)-369-1984"
    
    var body: some View {
        //Displays a drop down menu for country codes with the US country code being the default option.
        Picker("Country Code", selection: $countryCodeCount) {
            ForEach(0..<1) { _ in
                Text(countryCodes[countryCodeCount])
            }
        }
        .frame(height: 22)
        .padding(.vertical)
        .background(.white)
        .cornerRadius(roundedCornerRadius)
        //When the textfield is selected, a numeric keypad appears.
        TextField(phoneNumberplaceholder, text: $phoneNumber)
            .focused($numberIsFocused)
            .keyboardType(.numberPad)
            .padding(.all)
            .background(.white)
            .cornerRadius(roundedCornerRadius)
        //Formats the phone number a user types in as (###)-###-####.
            .onChange(of: phoneNumber) {
                phoneNumber = PartialFormatter().formatPartial(phoneNumber)
            }

    }
}

struct VerificationButtonView: View {
    @Binding var phoneNumber: String
    @FocusState.Binding var numberIsFocused: Bool
    @Binding var invalidNumberAlert: Bool
    @Binding var showVerificationView: Bool
    
    let invalidPhoneNumberPrompt = "Invalid Phone Number"
    
    var body: some View {
        Button("Get Verification Code") {
            //When the user taps the "Get Verification Code" button, the numberkey pad is dismissed. If the phone number entered is not the correct format or has more than 10 digits, an alert prompt will appear. If the phone number is correct, the API sends the code to phone number.
            numberIsFocused = false
            Task {
                do {
                    let parsedNumber = try phoneNumberKit.parse(phoneNumber)
                    e164PhoneNumber = phoneNumberKit.format(parsedNumber, toType: .e164)
                    let _ = try await Api.shared.sendVerificationToken(e164PhoneNumber: e164PhoneNumber)
                    showVerificationView = true
                } catch  {
                    invalidNumberAlert = true
                }
            }
        }
            .font(.custom(appFont, size: 18.0))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.all)
            .background(Color(buttonBackgroundColor))
            .cornerRadius(roundedCornerRadius)
            .navigationDestination(isPresented: $showVerificationView) {
                VerificationView()
            }
        // The alert prompt "Invalid Phone Number" appear when users type their phone numbers incorrectly."
            .alert(invalidPhoneNumberPrompt, isPresented: $invalidNumberAlert) {
                Button("OK") { }
            }
            .padding()
        

    }
}

#Preview {
    ContentView()
}
