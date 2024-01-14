//
//  ContentView.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/12/24.
//

import SwiftUI
import PhoneNumberKit

let phoneNumberKit = PhoneNumberKit()
let appBackgroundColor = Color(hue: 324.0, saturation: 0.15, brightness: 0.97)
let buttonBackgroundColor = Color(hue: 331.0, saturation: 0.38, brightness: 0.94)
let roundedCornerRadius = 10.0

let countryCodes = ["🇺🇸 US +1"]
let invalidPhoneNumberPrompt = "Invalid Phone Number"

struct ContentView: View {
    @State var phoneNumber: String = ""
    @State var countryCode: String = ""
    @State var invalidNumberAlert = false
    @FocusState var numberIsFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Image("PiggyBank Icon")
            Text("PiggyBank")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
                .frame(height: 30)
            Text("Enter your mobile phone number")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.black)
            Spacer()
                .frame(height: 20)
            HStack {
                Picker("Country Code", selection: $countryCode) {
                    Text(countryCodes[0])
                }
                .frame(height: 22)
                .padding(.vertical)
                .background(.white)
                .cornerRadius(roundedCornerRadius)
                TextField("(555)-369-1984", text: $phoneNumber)
                    .focused($numberIsFocused)
                    .keyboardType(.numberPad)
                    .padding(.all)
                    .background(.white)
                    .cornerRadius(roundedCornerRadius)
                    .onChange(of: phoneNumber) {
                        phoneNumber = PartialFormatter().formatPartial(phoneNumber)
                    }
            }
            Spacer()
                .frame(height: 30)
            VerificationButtonView(phoneNumber: $phoneNumber, numberIsFocused: $numberIsFocused, invalidNumberAlert: $invalidNumberAlert)
            Spacer()
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
        .background(appBackgroundColor)
        .onTapGesture {
            numberIsFocused = false
        }
    }
}

struct VerificationButtonView: View {
    @Binding var phoneNumber: String
    @FocusState.Binding var numberIsFocused: Bool
    @Binding var invalidNumberAlert: Bool
    
    var body: some View {
        Button("Get Verification Code") {
            numberIsFocused = false
            do {
                let parsedNumber = try phoneNumberKit.parse(phoneNumber)
                let formattedPhoneNumber = phoneNumberKit.format(parsedNumber, toType: .e164)
            } catch {
                invalidNumberAlert = true
            }
        }
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.all)
            .background(buttonBackgroundColor)
            .cornerRadius(roundedCornerRadius)
            .alert(invalidPhoneNumberPrompt, isPresented: $invalidNumberAlert) {
                Button("OK") { }
            }
    }
}

#Preview {
    ContentView()
}
