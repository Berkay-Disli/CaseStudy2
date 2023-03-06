//
//  AppUser.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 6.03.2023.
//

import Foundation

struct AppUser: Identifiable {
    let id = UUID().uuidString
    let displayName: String
    let email: String
    let profilePicURLString: String
}
