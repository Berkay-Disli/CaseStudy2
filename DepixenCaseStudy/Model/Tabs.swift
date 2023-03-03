//
//  Tabs.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import Foundation

enum Tabs: String, CaseIterable {
    case home, settings
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .settings:
            return "gearshape"
        }
    }
    
}
