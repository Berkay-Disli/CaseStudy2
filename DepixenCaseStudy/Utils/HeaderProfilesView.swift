//
//  HeaderProfilesView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 4.03.2023.
//

import SwiftUI
import Kingfisher

struct HeaderProfilesView: View {
    @EnvironmentObject var navVM: NavigationViewModel
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(authVM.usersList) { user in
                    VStack(spacing: 6) {
                        KFImage(URL(string: user.profilePicURLString))
                            .resizable()
                            .frame(width: 60, height: 60)
                            .scaledToFill()
                            .clipped()
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(Color("pri"), lineWidth: 2.5)
                            }
                        
                        Text(user.displayName)
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
            .environmentObject(AuthViewModel())
    }
}
