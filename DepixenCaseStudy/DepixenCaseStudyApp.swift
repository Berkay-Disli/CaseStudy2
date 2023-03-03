//
//  DepixenCaseStudyApp.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import SwiftUI

@main
struct DepixenCaseStudyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(NavigationViewModel())
        }
    }
}
