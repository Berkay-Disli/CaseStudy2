//
//  TabManager.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import SwiftUI

struct TabManager: View {
    @EnvironmentObject var navVM: NavigationViewModel
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                switch navVM.selectedTab {
                case .home:
                    Home()
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                case .newCard:
                    AddCardView()
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                case .settings:
                    Settings()
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                }
                
                if navVM.navBarIsShown {
                    VStack(spacing: 0) {
                        Divider()
                        HStack(alignment: .bottom) {
                            ForEach(Tabs.allCases, id:\.self) { tabItem in
                                VStack(spacing: 4) {
                                    Image(systemName: navVM.selectedTab == tabItem ? "\(tabItem.icon).fill":tabItem.icon)
                                        .font(.system(size: 21))
                                    Text(tabItem.title)
                                        .font(.system(size: 13))
                                }
                                .foregroundColor(navVM.selectedTab == tabItem ? Color("pri"):.black.opacity(0.7))
                                .padding(.horizontal)
                                .padding(.top, 4)
                                .hAlign(.center)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        navVM.changeNavigationTab(tabItem)
                                    }
                                }
                            }
                        }
                    }
                    .background(.regularMaterial)
                }
                
                
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        
    }
}

struct TabManager_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
            .environmentObject(NavigationViewModel())
    }
}

extension View {
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}
