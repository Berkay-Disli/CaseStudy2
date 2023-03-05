//
//  ContentView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var navVM: NavigationViewModel
    
    var body: some View {
        if authVM.userSession != nil {
            if navVM.onboarding && !authVM.directLogin {
                OnboardingView(fullname: authVM.userSession?.displayName ?? "user")
                    .transition(AnyTransition.opacity.animation(.easeInOut))
            } else {
                TabManager()
                    .transition(AnyTransition.opacity.animation(.easeInOut))
            }
        } else {
            Login()
                .transition(AnyTransition.opacity.animation(.easeInOut))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
            .environmentObject(NavigationViewModel())
    }
}
