//
//  Settings.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import SwiftUI
import Kingfisher

struct Settings: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var navVM: NavigationViewModel
    @State private var signOutAlertIsShown = false
    
    var body: some View {
        NavigationView {
            List {
                if let user = authVM.userSession {
                    Section {
                        HStack {
                            KFImage(authVM.userProfileImageUrl)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(Color("pri"), lineWidth: 2)
                                }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.displayName?.capitalized ?? "")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                
                                Text(verbatim: user.email ?? "")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                        }
                    } header: {
                        Text("Profile")
                    }
                }
                
                Section {
                    ForEach(1...6, id:\.self) { item in
                        Label {
                            Text("Setting \(item)")
                        } icon: {
                            Image(systemName: "gearshape")
                                .foregroundColor(.black)
                        }

                    }
                    
                    Button {
                        signOutAlertIsShown = true
                    } label: {
                        Label {
                            Text("Sign Out")
                        } icon: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                    }
                    .foregroundColor(.red)
                    .alert("Do you want to sign out?", isPresented: $signOutAlertIsShown) {
                        Button(role: .destructive) {
                            do {
                                try authVM.signOut()
                                authVM.loadingAnimation = false
                                navVM.changeNavigationTab(.home)
                            } catch {
                                print(error)
                            }
                        } label: {
                            Text("Yes")
                        }
                        .alert(authVM.errorMessage, isPresented: $authVM.showError, actions: {} )
                        
                    }
                    
                } header: {
                    Text("General")
                }
                

                
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            
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
