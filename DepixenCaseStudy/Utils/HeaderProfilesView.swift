//
//  HeaderProfilesView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 4.03.2023.
//

import SwiftUI

struct HeaderProfilesView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(1...15, id:\.self) { item in
                    VStack(spacing: 6) {
                        Circle().stroke(Color("pri"), lineWidth: 2.5)
                            .frame(width: 60, height: 60)
                        
                        Text("User: \(item)")
                            .font(.system(size: 13))
                    }
                }
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 12)
        }
    }
}

struct HeaderProfilesView_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
            .environmentObject(NavigationViewModel())
    }
}
