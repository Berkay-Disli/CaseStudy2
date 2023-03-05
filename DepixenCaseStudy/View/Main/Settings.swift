//
//  Settings.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var navVM: NavigationViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings View is here!")
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        do {
                            try authVM.signOut()
                            authVM.loadingAnimation = false
                            navVM.changeNavigationTab(.home)
                        } catch {
                            print(error)
                        }
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(Color("pri"))
                    }

                }
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
            .environmentObject(AuthViewModel())
            .environmentObject(NavigationViewModel())
    }
}
