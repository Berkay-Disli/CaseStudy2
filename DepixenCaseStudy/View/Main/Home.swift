//
//  Home.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var navVM: NavigationViewModel
    
    let twoColumns: [GridItem] = [GridItem(.flexible(), spacing: 12),
                               GridItem(.flexible())]
    let threeColumns: [GridItem] = [GridItem(.flexible(), spacing: 12),
                               GridItem(.flexible(), spacing: 12),
                               GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: navVM.gridChoice == .twoColumns ? twoColumns:threeColumns, spacing: 12) {
                    ForEach(1...15, id:\.self) { item in
                        RoundedRectangle(cornerRadius: 10).stroke(Color("pri"), lineWidth: 2)
                            .frame(height: navVM.gridChoice == .twoColumns ? 260:170)
                    }
                }
                .padding()
                .padding(.bottom, 46)
            }
            .navigationTitle("Home")
            .toolbar {
                // To add another function, i could use this area as well. for example:
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation(.easeInOut) {
                            navVM.toggleGridChoice()
                        }
                    } label: {
                        Image(systemName: "rectangle.grid.3x2.fill")
                            .foregroundColor(Color("pri"))
                    }

                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
            .environmentObject(NavigationViewModel())
    }
}
