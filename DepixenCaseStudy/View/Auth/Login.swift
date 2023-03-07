//
//  Login.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 5.03.2023.
//

import SwiftUI
import RiveRuntime

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var navVM: NavigationViewModel
    
    var loginRiveView = RiveViewModel(fileName: "login")
    
    enum FocusField: Hashable {
        case email, password
    }
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        
        NavigationView {
            let primaryColor = Color("pri")
            VStack {
                loginRiveView.view()
                    .frame(height: 200)
                    .padding(.bottom, -45)
                
                //header
                VStack(alignment: .leading) {
                    Text("Hello.")
                    Text("Welcome back.")
                        .foregroundColor(primaryColor)
                }
                .font(.largeTitle).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                .onTapGesture {
                    disableFocusedField()
                }
                
                VStack(spacing: 40) {
                    CustomTextField(image: "envelope", placeholder: "email", text: $email, isSecure: false, textContentType: .emailAddress)
                        .focused($focusedField, equals: .email)
                    CustomTextField(image: "lock", placeholder: "password", text: $password, isSecure: true, textContentType: nil)
                        .focused($focusedField, equals: .password)
                }
                .padding([.horizontal, .top], 32)
                
                NavigationLink {
                    Text("Reset password page..")
                } label: {
                    Text("Forgot Password?")
                        .font(.system(size: 13)).fontWeight(.semibold)
                        .foregroundColor(primaryColor)
                        .padding()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                
                
                Button {
                    //authVM.signInWithEmail(email: email, password: password)
                    Task {
                        do {
                            try await authVM.signInWithEmailAsync(email: email, password: password)
                            navVM.disableOnboarding()
                        } catch {
                            await authVM.setError(error)
                        }
                    }
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 50)
                        .background(primaryColor)
                        .clipShape(Capsule())
                        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                }
                
                
                
                Spacer()
                
                #warning("When keyboard is enabled, if you go to register and turn back, this stays above.")
                NavigationLink {
                    Register()
                } label: {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                        Text("Sign up.")
                            .font(.system(size: 14)).fontWeight(.semibold)
                    }
                    .foregroundColor(primaryColor)
                }
            }
            .background(content: {
                Color.white.ignoresSafeArea()
                    .onTapGesture {
                        disableFocusedField()
                    }
            })
            .onAppear {
                authVM.setDirectLogin(false)
                navVM.disableOnboarding()
            }
            .padding()
            .overlay {
                if authVM.loadingAnimation {
                    ProgressView()
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                }
            }
            .alert(authVM.errorMessage, isPresented: $authVM.showError, actions: {})
        }
        .toolbar(.hidden)
    }
    
    func disableFocusedField() {
        withAnimation(.easeInOut) {
            focusedField = nil
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
            .environmentObject(NavigationViewModel())
            .environmentObject(AuthViewModel())
    }
}
