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
    @State private var darkModeEnabled = false
    @State private var notificationsEnabled = true
    @State private var autoLogin = true
    @State private var disableAnimations = false
    
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
                        Text("PROFILE")
                    }
                }
                
                Section {
                    NavigationLink("Depixen - Case Study") {
                        CaseStudyInfoView()
                    }
                    
                    NavigationLink("Berkay Dişli") {
                        Text("Berkay Dişli")
                    }
                } header: {
                    Text("APP INFO")
                } footer: {
                    Text("Check to see more info about the app and the owner.")
                }

                
                Section {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Notifications", systemImage: "bell")
                            .foregroundColor(.black)
                    }
                    
                    Toggle(isOn: $autoLogin) {
                        Label("Stay logged in", systemImage: "person")
                            .foregroundColor(.black)
                    }
                    
                    Toggle(isOn: $darkModeEnabled) {
                        Label("Dark mode", systemImage: "lightbulb")
                            .foregroundColor(.black)
                    }
                    
                    Toggle(isOn: $disableAnimations) {
                        Label("Less animations", systemImage: "hand.draw")
                            .foregroundColor(.black)
                    }
                    
                    Button {
                        signOutAlertIsShown = true
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
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
