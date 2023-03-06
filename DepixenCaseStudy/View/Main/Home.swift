//
//  Home.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var navVM: NavigationViewModel
    @EnvironmentObject var authVM: AuthViewModel
    
    let twoColumns: [GridItem] = [GridItem(.flexible(), spacing: 12),
                                  GridItem(.flexible())]
    let threeColumns: [GridItem] = [GridItem(.flexible(), spacing: 12),
                                    GridItem(.flexible(), spacing: 12),
                                    GridItem(.flexible())]
    
    @State private var expandCard = false
    
    var body: some View {
        NavigationView {
            ZStack(content: {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        HeaderProfilesView()
                        
                        Divider()
                        
                        LazyVGrid(columns: navVM.gridChoice == .twoColumns ? twoColumns:threeColumns, spacing: 12) {
                            ForEach(authVM.cardsList.indices, id:\.self) { item in
                                /// On tap gesture, create a bigger view that shows the same card but the size if bigger. --CHECK
                                /// Make it on another swift file for easy reading. --CHECK
                                /// Establish a smooth expanding view animation using matched geometry effect. --NOT A SOLID CHECK I'M AFRAID...
                                CardView(color: authVM.cardsList[item].color, title: authVM.cardsList[item].title, description: authVM.cardsList[item].description, image: authVM.cardsList[item].image ?? "", author: authVM.cardsList[item].author)
                                    .onTapGesture {
                                        //withAnimation(.easeInOut) {
                                            expandCard = true
                                        //}
                                    }
                            }
                        }
                        .padding()
                        .padding(.bottom, 46)
                        
                    }
                }
                .onAppear {
                    Task {
                        do {
                            try await authVM.getCardsFromFirestore()
                        } catch {
                            print(error)
                        }
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
            .environmentObject(AuthViewModel())
            
    }
}
