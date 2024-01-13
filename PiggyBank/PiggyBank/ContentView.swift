//
//  ContentView.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/12/24.
//

import SwiftUI

struct ContentView: View {
    @State var name: String = ""
    @State var countryCode: String = ""
    let countryCodes = ["🇺🇸 US +1"]
    var body: some View {
        VStack(spacing: 0) {
            Image("PiggyBank Icon")
            Text("PiggyBank")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
                .frame(height: 30)
            Text("Enter your mobile number")
                .font(.title2)
                .fontWeight(.medium)
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
                TextField("(555)-369-1984", text: $name)
                    .padding(.all)
                    .background(.white)
                    .cornerRadius(10.0)
            }
            Spacer()
                .frame(height: 30)
            Button {
                
            } label: {
                Text("Get Verification Code")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
            }
                .padding(.all)
                .background(Color(hue: 331.0, saturation: 0.38, brightness: 0.94))
                .cornerRadius(10.0)
            Spacer()
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
        .background(Color(hue: 324.0, saturation: 0.15, brightness: 0.97))
    }
}

#Preview {
    ContentView()
}
