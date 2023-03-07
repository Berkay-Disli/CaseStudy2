//
//  Register.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 5.03.2023.
//

import SwiftUI
import PhotosUI

struct Register: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var username = ""
    
    @State private var selectedItem = [PhotosPickerItem]()
    @State private var data: Data?
    
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var navVM: NavigationViewModel
    @Environment(\.dismiss) var dismiss
    
    enum FocusField: Hashable {
        case fullname, username, email, password
    }
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        VStack {
            let primaryColor = Color("pri")
            
            // MARK: Blank frames to adjust layout to show specific textfield when keyboard is enabled.
            switch focusedField {
            case .fullname:
                Rectangle().fill(.clear)
                    .frame(height: 220)
            case .username:
                Rectangle().fill(.clear)
                    .frame(height: 180)
            case .email:
                Rectangle().fill(.clear)
                    .frame(height: 30)
            case .password:
                EmptyView()
            case .none:
                EmptyView()
            }
            
            VStack(alignment: .leading) {
                Text("Hello \(fullname)\(fullname.count > 2 ? ".":"")")
                    .animation(.easeInOut, value: fullname)
                Text("Create your account.")
                    .foregroundColor(primaryColor)
            }
            .font(.largeTitle).bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top)
            .onTapGesture {
                disableFocusedField()
            }
            
            VStack(spacing: 40) {
                if let data {
                    if let image = UIImage(data: data) {
                        PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, matching: .images) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 140, height: 140)
                                .overlay {
                                    Circle()
                                        .stroke(LinearGradient(colors: [primaryColor, primaryColor, primaryColor, .black], startPoint: .top, endPoint: .bottom), lineWidth: 3)
                                        .frame(width: 140, height: 140)
                                }
                            /*
                                .onTapGesture {
                                    disableFocusedField()
                                }
                             */
                        }.onChange(of: selectedItem) { newValue in
                            guard let item = selectedItem.first else { return }
                            item.loadTransferable(type: Data.self) { result in
                                switch result {
                                case .success(let data):
                                    guard let data else { return }
                                    self.data = data
                                case .failure(let failure):
                                    print(failure)
                                }
                            }
                        }
                    }
                } else {
                    PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, matching: .images) {
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .foregroundColor(.black)
                            .overlay {
                                Circle()
                                    .stroke(.black, lineWidth: 3)
                                    .frame(width: 140, height: 140)
                            }
                            .frame(height: 140)
                        /*
                            .onTapGesture {
                                disableFocusedField()
                            }
                         */
                    }.onChange(of: selectedItem) { newValue in
                        guard let item = selectedItem.first else { return }
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                guard let data else { return }
                                self.data = data
                            case .failure(let failure):
                                print(failure)
                            }
                        }
                    }
                }
                
                Group {
                    CustomTextField(image: "person", placeholder: "fullname", text: $fullname, isSecure: false, textContentType: .name)
                        .focused($focusedField, equals: .fullname)
                        .textInputAutocapitalization(.characters)
                    CustomTextField(image: "person", placeholder: "username", text: $username, isSecure: false, textContentType: .username)
                        .focused($focusedField, equals: .username)
                    CustomTextField(image: "envelope", placeholder: "email", text: $email, isSecure: false, textContentType: .emailAddress)
                        .focused($focusedField, equals: .email)
                        .keyboardType(.emailAddress)
                    CustomTextField(image: "lock", placeholder: "password", text: $password, isSecure: true, textContentType: nil)
                        .focused($focusedField, equals: .password)
                        .autocorrectionDisabled()
                }
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            }
            .padding([.horizontal], 32)
            
            Button {
                if let data {
                    if let image = UIImage(data: data) {
                        Task {
                            do {
                                try await authVM.createAccountWithEmailAsync(email:email, username: username, fullname: fullname, password: password, image: image)
                                navVM.enableOnboarding()
                            } catch {
                                await authVM.setError(error)
                            }
                        }
                    }
                }
                
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 50)
                    .background(data == nil ? .gray:primaryColor)
                    .clipShape(Capsule())
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                    .padding(.horizontal).padding(.top, 24)
                    .disabled(data == nil ? true:false)
            }
            
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .font(.system(size: 14))
                    Text("Sign in.")
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
        .toolbar(.hidden)
        .padding()
        .overlay {
            if authVM.loadingAnimation {
                ProgressView()
                    .transition(AnyTransition.opacity.animation(.easeInOut))
            }
        }
        .alert(authVM.errorMessage, isPresented: $authVM.showError, actions: {})
        .toolbar(.hidden)
    }
    
    func disableFocusedField() {
        withAnimation(.easeInOut) {
            focusedField = nil
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
            .environmentObject(AuthViewModel())
            .environmentObject(NavigationViewModel())
    }
}
