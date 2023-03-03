//
//  SilSonra.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 4.03.2023.
//

import SwiftUI

struct SilSonra: View {
    let twoColumns: [GridItem] = [GridItem(.flexible(), spacing: 12),
                                  GridItem(.flexible())]
    let threeColumns: [GridItem] = [GridItem(.flexible(), spacing: 12),
                                    GridItem(.flexible(), spacing: 12),
                                    GridItem(.flexible())]
    
    @State private var twoCol = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    LazyVGrid(columns: twoCol ? twoColumns:threeColumns) {
                        ForEach(1...12, id:\.self) { item in
                            RoundedRectangle(cornerRadius: 10).fill(.cyan)
                                .frame(height: twoCol ? 260:170)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .padding([.bottom, .horizontal])
            .navigationTitle("Sil aq sil")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation(.easeInOut) {
                            self.twoCol.toggle()
                        }
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }

                }
            }
            .edgesIgnoringSafeArea(.bottom)

        }
    }
}

struct SilSonra_Previews: PreviewProvider {
    static var previews: some View {
        SilSonra()
    }
}
