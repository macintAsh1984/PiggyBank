//
//  HomePageView.swift
//  PiggyBank
//
//  Created by Ashley Valdez on 1/23/24.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        VStack {
            Image("PiggyBank Icon")
            Text("Every Cent Counts!")
                .font(.custom(appFont, size: 40.0, relativeTo: .title))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity, maxHeight: .infinity/*@END_MENU_TOKEN@*/)
        .background(Color(appBackgroundColor))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomePageView()
}
