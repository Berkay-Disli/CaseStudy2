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
    
    let cardItems: [CardItem] = [.init(color: .purple, title: "Item 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try1", author: "author1"),
                                 .init(color: .purple, title: "Item 2", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try2", author: "author2"),
                                 .init(color: .purple, title: "Item 3", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try3", author: "author3"),
                                 .init(color: .purple, title: "Item 4", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try4", author: "author4"),
                                 .init(color: .purple, title: "Item 5", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try5", author: "author5"),
                                 .init(color: .purple, title: "Item 6", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try6", author: "author6")]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: navVM.gridChoice == .twoColumns ? twoColumns:threeColumns, spacing: 0) {
                    ForEach(cardItems) { item in
                        CardView(color: item.color, title: item.title, description: item.description, image: item.image)
                    }
                }
                .padding([.bottom, .horizontal])
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
