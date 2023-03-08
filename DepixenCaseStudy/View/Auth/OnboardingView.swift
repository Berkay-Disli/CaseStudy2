//
//  OnboardingView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 5.03.2023.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var navVM: NavigationViewModel
    
    let fullname: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hey \(fullname)")
            Text("Welcome to the app.")
                .fontWeight(.medium)
                .foregroundColor(Color("pri"))
        }
        .font(.title)
        .hAlign(.leading)
        .vAlign(.center)
        .padding(.horizontal)
        .background(Color("bg"))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                navVM.disableOnboarding()
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(fullname: "Berkay")
            .environmentObject(NavigationViewModel())
    }
}
