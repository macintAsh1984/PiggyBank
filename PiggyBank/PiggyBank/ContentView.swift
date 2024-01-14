//
//  ContentView.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/12/24.
//

import SwiftUI
import PhoneNumberKit

let phoneNumberKit = PhoneNumberKit()

struct ContentView: View {
    @State var phoneNumber: String = ""
    @State var countryCode: String = ""
    @State var invalidNumberAlert = false
    @FocusState var numberIsFocused: Bool
    
    let countryCodes = ["🇺🇸 US +1"]
    
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
                .cornerRadius(10.0)
                TextField("(555)-369-1984", text: $phoneNumber)
                    .focused($numberIsFocused)
                    .keyboardType(.numberPad)
                    .padding(.all)
                    .background(.white)
                    .cornerRadius(10.0)
                    .onChange(of: phoneNumber) {
                        phoneNumber = PartialFormatter().formatPartial(phoneNumber)
                    }
            }
            Spacer()
                .frame(height: 30)
            Button {
                numberIsFocused = false
                do {
                    let parsedNumber = try phoneNumberKit.parse(phoneNumber)
                    let formattedPhoneNumber = phoneNumberKit.format(parsedNumber, toType: .e164)
                } catch {
                    invalidNumberAlert = true
                }
            } label: {
                Text("Get Verification Code")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
            }
                .padding(.all)
                .background(Color(hue: 331.0, saturation: 0.38, brightness: 0.94))
                .cornerRadius(10.0)
                .alert("Invalid Phone Number", isPresented: $invalidNumberAlert) {
                    Button("OK") { }
                }

            Spacer()
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
        .background(Color(hue: 324.0, saturation: 0.15, brightness: 0.97))
        .onTapGesture {
            numberIsFocused = false
        }
    }
}

#Preview {
    ContentView()
}
