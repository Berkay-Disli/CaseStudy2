//
//  Settings.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var authVM: AuthViewModel
    var body: some View {
        #warning("A button needed to sign out!")
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
        Settings()
            .environmentObject(AuthViewModel())
    }
}
