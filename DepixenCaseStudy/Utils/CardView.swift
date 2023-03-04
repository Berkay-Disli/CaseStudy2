//
//  CardView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 3.03.2023.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var navVM: NavigationViewModel
    let color: Color
    let title: String
    let description: String
    let image: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            RoundedRectangle(cornerRadius: 10).fill(color)
                .frame(width: navVM.gridChoice == .twoColumns ? 60:40, height: navVM.gridChoice == .twoColumns ?  30:30)
                .offset(y: navVM.gridChoice == .twoColumns ? 20:25)
                .padding(.top, navVM.gridChoice == .twoColumns ? -20:-25)
            
            RoundedRectangle(cornerRadius: 10).stroke(Color("pri"), lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .frame(height: navVM.gridChoice == .twoColumns ? 260:170)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                            .font(.system(size: navVM.gridChoice == .twoColumns ? 15:14))
                            .fontWeight(.medium)
                            .foregroundColor(Color("pri"))
                            .padding([.leading, .top], 7)
                            
                        
                        Rectangle().colorInvert()
                            .frame(height: navVM.gridChoice == .twoColumns ? 70:48)
                            .overlay(alignment: .topLeading, content: {
                                Text("ahjkdka akjsd ajkdkajkds jasdk ajkdslasd")
                                    .font(.system(size: navVM.gridChoice == .twoColumns ? 13:11))
                            })
                            .padding(.horizontal, 8)
                            
                        Divider()
                            .padding(.vertical, navVM.gridChoice == .twoColumns ? 4:1)
                        
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: .infinity, height: navVM.gridChoice == .twoColumns ? 114:73)
                            .hAlign(.center)
                        
                        Text("author")
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
    }
}