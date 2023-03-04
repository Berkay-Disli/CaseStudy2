//
//  AddCardView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 4.03.2023.
//

import SwiftUI

struct AddCardView: View {
    @State private var color: Color = Color("pri")
    @State private var title = ""
    @State private var description = "New Description"
    @State private var image: Image?
    
    var body: some View {
        NavigationView {
            VStack {
                RoundedRectangle(cornerRadius: 10).fill(color)
                    .frame(width: 50, height: 25)
                    .hAlign(.leading)
                    .offset(y: 20)
                
                RoundedRectangle(cornerRadius: 10).stroke(color, lineWidth: 2)
                    .frame(height: 500)
                    .overlay {
                        VStack {
                            TextField("New Title", text: $title.max(22))
                                .font(.title)
                                .foregroundColor(color)
                                .autocorrectionDisabled()
                                //.border(.red)
                                .background(.white)
                                
                            
                            TextEditor(text: $description)
                                .border(.cyan)
                                .frame(height: 200)
                        }
                        .vAlign(.top)
                        .padding([.horizontal, .top])
                    }
                
                
                
                
                
            }
            .padding(.horizontal)
            .vAlign(.top)
            .navigationTitle("Create a new card")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("pri"))
                    }

                }
            }
        }
    }
}

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
            .environmentObject(NavigationViewModel())
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
