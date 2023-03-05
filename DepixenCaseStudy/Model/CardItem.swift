//
//  CardItem.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import Foundation
import SwiftUI

struct CardItem: Identifiable {
    let id = UUID().uuidString // perhaps change it to firebase id?
    let color: Color
    let title: String
    let description: String
    let image: Data
}
