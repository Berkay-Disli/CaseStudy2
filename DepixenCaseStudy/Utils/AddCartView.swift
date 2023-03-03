//
//  AddCardView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 4.03.2023.
//

import SwiftUI

struct AddCardView: View {
    @EnvironmentObject var navVM: NavigationViewModel

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                
                    
            }
            .vAlign(.center)
            .navigationTitle("New Card")
        }
    }
}

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
            .environmentObject(NavigationViewModel())
    }
}
