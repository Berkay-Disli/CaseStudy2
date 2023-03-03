//
//  NavigationViewModel.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import Foundation

class NavigationViewModel: ObservableObject {
    @Published var onboarding = false
    @Published private(set) var selectedTab: Tabs = .home
    @Published private(set) var navBarIsShown: Bool = true
    @Published private(set) var gridChoice: GridChoices = .twoColumns
    
    init() {
        
    }
    
    func setGridChoice(_ gridChoice: GridChoices) {
        self.gridChoice = gridChoice
    }
    
    func toggleGridChoice() {
        if gridChoice == .twoColumns {
            gridChoice = .threeColumns
        } else if gridChoice == .threeColumns {
            gridChoice = .twoColumns
        }
    }
    
    func enableNavBar() {
        navBarIsShown = true
    }
    
    func disableNavBar() {
        navBarIsShown = false
    }
    
    func changeNavigationTab(_ tab: Tabs) {
        selectedTab = tab
    }
    
    func enableOnboarding() {
        onboarding = true
    }
    func disableOnboarding() {
        onboarding = false
    }
}
