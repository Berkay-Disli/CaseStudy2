//
//  AddCardView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 4.03.2023.
//

import SwiftUI
import PhotosUI

struct AddCardView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var navVM: NavigationViewModel
    
    @State private var color: Color = Color("pri")
    @State private var title = ""
    @State private var description = ""
    @State private var image: Image?
    
    // text fields
    enum FocusField: Hashable {
        case title, description
    }
    
    @FocusState private var focusedField: FocusField?
    
    // image
    @State private var selectedItem = [PhotosPickerItem]()
    @State private var data: Data?
    
    // alerts
    @State private var deleteCardInfoAlertIsShown = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10).fill(color)
                    .frame(width: 50, height: 25)
                    .hAlign(.leading)
                    .offset(y: 20)
                    .padding(.top, focusedField != nil ? 200:0)
                    
                
                RoundedRectangle(cornerRadius: 10).stroke(color, lineWidth: 2)
                    .frame(height: 500)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 10).fill(.white)
                    })
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            dismissFocusFromTextField()
                        }
                    }
                    .overlay {
                        VStack {
                            HStack {
                                TextField("New Title", text: $title.max(17))
                                    .font(.title)
                                    .fontWeight(.medium)
                                    .foregroundColor(color)
                                    .autocorrectionDisabled()
                                    .focused($focusedField, equals: .title)

                                ColorPicker("", selection: $color)
                                    .frame(width: 30)
                            }
                            
                            // TextEditor
                            #warning("not tappable in actual device sometimes? why")
                            ZStack {
                                if self.description.isEmpty {
                                    TextEditor(text: .constant("New Description"))
                                            .font(.body)
                                            .foregroundColor(.gray)
                                            .disabled(true)
                                            .autocorrectionDisabled()
                                            
                                }
                                TextEditor(text: $description)
                                    .font(.body)
                                    .opacity(self.description.isEmpty ? 0.25 : 1)
                                    .focused($focusedField, equals: .description)
                                    .autocorrectionDisabled()
                            }
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 10).stroke(Color(uiColor: .lightGray))
                            })
                            .frame(height: 170)
                            
                            if let data {
                                if let image = UIImage(data: data) {
                                    PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, matching: .images) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 227)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .clipped()
                                    }.onChange(of: selectedItem) { newValue in
                                        
                                        guard let item = selectedItem.first else { return }
                                        item.loadTransferable(type: Data.self) { result in
                                            switch result {
                                            case .success(let data):
                                                guard let data else { return }
                                                self.data = data
                                                dismissFocusFromTextField()
                                            case .failure(let failure):
                                                print(failure)
                                            }
                                        }
                                    }
                                }
                            } else {
                                PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, matching: .images) {
                                    RoundedRectangle(cornerRadius: 10).stroke(Color(uiColor: .lightGray))
                                        .frame(height: 227)
                                        .overlay {
                                            HStack {
                                                Image(systemName: "plus")
                                                Text("Add Image")
                                            }
                                            .font(.title)
                                            .foregroundColor(Color(uiColor: .lightGray))
                                        }
                                }.onChange(of: selectedItem) { newValue in
                                    guard let item = selectedItem.first else { return }
                                    item.loadTransferable(type: Data.self) { result in
                                        switch result {
                                        case .success(let data):
                                            guard let data else { return }
                                            self.data = data
                                            dismissFocusFromTextField()
                                        case .failure(let failure):
                                            print(failure)
                                        }
                                    }
                                }
                            }
                            
                            
                            
                            Text("author")
                                .font(.system(size: 14))

                        }
                        .vAlign(.top)
                        .padding([.horizontal, .top])
                    }
                
                // Post Card
                Button {
                    Task {
                        guard let data else { throw URLError(.cannotOpenFile)}
                        do {
                            try await authVM.postCardToFirestore(CardItem(color: color, title: title, description: description, data: data, author: authVM.userSession?.displayName ?? "", image: nil))
                            try await authVM.getCardsFromFirestore()
                            navVM.changeNavigationTab(.home)
                        } catch {
                            print(error)
                        }
                        
                    }
                } label: {
                    Text("Post the Card")
                        .font(.title)
                        .foregroundColor(color)
                }
                .padding(.top, 12)
                
                Spacer()
            }
            .overlay(content: {
                if authVM.loadingAnimation {
                    ProgressView()
                        .transition(.opacity.animation(.easeInOut))
                }
            })
            .padding(.horizontal)
            .padding(.bottom, 50)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationTitle("Create a new card")
            .navigationBarTitleDisplayMode(focusedField != nil ? .inline:.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismissFocusFromTextField()
                        deleteCardInfoAlertIsShown.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("pri"))
                    }
                    .alert("Do you want to delete the card details?", isPresented: $deleteCardInfoAlertIsShown) {
                        Button(role: .destructive) {
                            withAnimation(.easeInOut) {
                                self.title = ""
                                self.description = ""
                                self.color = Color("pri")
                                self.data = nil
                            }
                        } label: {
                            Text("Delete")
                        }
                    }
                }
            }
        }
    }
    
    func dismissFocusFromTextField() {
        focusedField = nil
    }
}

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
            .environmentObject(NavigationViewModel())
            .environmentObject(AuthViewModel())
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
