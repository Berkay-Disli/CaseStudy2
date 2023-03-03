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
            
            RoundedRectangle(cornerRadius: 10).stroke(Color("pri"), lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .frame(height: navVM.gridChoice == .twoColumns ? 260:170)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .foregroundColor(Color("pri"))
                            .padding([.leading, .top], 7)
                            
                        Text(description)
                            .font(.system(size: 13))
                            .frame(height: 100)
                            .padding(.horizontal, 8)
                            
                        Divider()
                            .padding(.vertical, 4)
                        
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: .infinity, height: 100)
                            .hAlign(.center)
                        
                        Text("author")
                            .font(.system(size: 9))
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
