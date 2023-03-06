//
//  CardView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import SwiftUI
import Kingfisher

struct CardView: View {
    @EnvironmentObject var navVM: NavigationViewModel
    @EnvironmentObject var authVM: AuthViewModel
    let color: Color
    let title: String
    let description: String
    let image: String
    let author: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            RoundedRectangle(cornerRadius: 10).fill(color)
                .frame(width: navVM.gridChoice == .twoColumns ? 60:40, height: navVM.gridChoice == .twoColumns ?  30:30)
                .offset(y: navVM.gridChoice == .twoColumns ? 20:25)
                .padding(.top, navVM.gridChoice == .twoColumns ? -20:-25)
            
            RoundedRectangle(cornerRadius: 10).stroke(color, lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .frame(height: navVM.gridChoice == .twoColumns ? 260:170)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                            .font(.system(size: navVM.gridChoice == .twoColumns ? 15:14))
                            .fontWeight(.medium)
                            .foregroundColor(color)
                            .padding([.leading, .top], 7)
                            .padding(.bottom, navVM.gridChoice == .twoColumns ? 4:1)
                        
                        Rectangle().colorInvert()
                            .frame(height: navVM.gridChoice == .twoColumns ? 70:48)
                            .overlay(alignment: .topLeading, content: {
                                Text(description)
                                    .font(.system(size: navVM.gridChoice == .twoColumns ? 13:11))
                            })
                            .padding(.horizontal, 8)
                            
                        Divider()
                            .padding(.vertical, navVM.gridChoice == .twoColumns ? 4:1)
                        
                        KFImage(URL(string: image))
                            .resizable()
                            .scaledToFill()
                            .frame(width: navVM.gridChoice == .twoColumns ? 160:100, height: navVM.gridChoice == .twoColumns ? 130:78)
                            
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .clipped()
                            .hAlign(.center)
                            .padding(.top, 4)
                        
                        Text(author)
                            .font(.system(size: navVM.gridChoice == .twoColumns ? 9:7))
                            .foregroundColor(.gray)
                            .vAlign(.center)
                            .hAlign(.center)
                            
                            
                            
                    }
                }
                
            
        }
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
            .environmentObject(NavigationViewModel())
            .environmentObject(AuthViewModel())
    }
}
