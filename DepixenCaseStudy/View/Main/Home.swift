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
    
    @State private var expandCard = false
    
    /*
    let cardItems: [CardItem] = [.init(color: .purple, title: "Item 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try1", author: "author1"),
                                 .init(color: .purple, title: "Item 2", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try2", author: "author2"),
                                 .init(color: .purple, title: "Item 3", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try3", author: "author3"),
                                 .init(color: .purple, title: "Item 4", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try4", author: "author4"),
                                 .init(color: .purple, title: "Item 5", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try5", author: "author5"),
                                 .init(color: .purple, title: "Item 6", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try6", author: "author6"),
                                 .init(color: .purple, title: "Item 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try1", author: "author1"),
                                 .init(color: .purple, title: "Item 2", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try2", author: "author2"),
                                 .init(color: .purple, title: "Item 3", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try3", author: "author3"),
                                 .init(color: .purple, title: "Item 4", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try4", author: "author4"),
                                 .init(color: .purple, title: "Item 5", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try5", author: "author5"),
                                 .init(color: .purple, title: "Item 6", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", image: "try6", author: "author6")]
    */
    
    var body: some View {
        NavigationView {
            ZStack(content: {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        HeaderProfilesView()
                        
                        Divider()
                        /*
                        LazyVGrid(columns: navVM.gridChoice == .twoColumns ? twoColumns:threeColumns, spacing: 12) {
                            ForEach(cardItems.indices, id:\.self) { item in
                                /// On tap gesture, create a bigger view that shows the same card but the size if bigger. --CHECK
                                /// Make it on another swift file for easy reading. --CHECK
                                /// Establish a smooth expanding view animation using matched geometry effect. --NOT A SOLID CHECK I'M AFRAID...
                                CardView(color: cardItems[item].color, title: cardItems[item].title, description: cardItems[item].description, image: cardItems[item].image)
                                    .onTapGesture {
                                        //withAnimation(.easeInOut) {
                                            expandCard = true
                                        //}
                                    }
                            }
                        }
                        .padding()
                        .padding(.bottom, 46)
                        */
                    }
                }
                
                if expandCard {
                        Rectangle().fill(.clear)
                            .ignoresSafeArea()
                            .backgroundBlur(radius: 3)
                            .animation(.easeInOut, value: expandCard)
                            .transition(.opacity.animation(.easeInOut(duration: 0.25)))
                            .onTapGesture {
                                expandCard = false
                            }
                            .zIndex(1)
                         
                        PresentingCardView(color: .pink, title: "Presenting", description: "Presenting card description is here! Hello there.", image: "try8", expandCard: $expandCard)
                            .offset(y: -40)
                            .transition(.scale.animation(.easeInOut(duration: 0.25)))
                            .zIndex(2)
                    
                }
            })
            
            .navigationTitle("Home")
            .toolbar {
                // To add another function, i could use this area as well. for example:
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation(.easeInOut) {
                            navVM.toggleGridChoice()
                        }
                    } label: {
                        Image(systemName: "rectangle.grid.\(navVM.gridChoice == .twoColumns ? 2:3)x2.fill")
                            .foregroundColor(Color("pri"))
                    }
                    
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Circle().stroke(.pink, lineWidth: 2)
                        .frame(width: 25)
                        .overlay {
                            Image(systemName: "person")
                                .font(.system(size: 10))
                                .foregroundColor(.pink)
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
