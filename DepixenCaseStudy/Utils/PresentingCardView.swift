//
//  PresentingCardView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 5.03.2023.
//

import SwiftUI
import Kingfisher

struct PresentingCardView: View {
    @EnvironmentObject var navVM: NavigationViewModel
    @EnvironmentObject var authVM: AuthViewModel
    let color: Color
    let title: String
    let description: String
    let image: String
    let author: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10).fill(color)
                .frame(width: 50, height: 25)
                .hAlign(.leading)
                .offset(y: 20)
                .padding(.leading, -8)
                
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(color)
                    .autocorrectionDisabled()
                    .hAlign(.leading)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.horizontal).padding(.vertical, 8)
                    .hAlign(.leading)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 10).stroke(Color(uiColor: .lightGray))
                            .frame(width: UIScreen.main.bounds.width - 50)
                    })
                
                Divider()
                    .padding(.vertical, 4)
                
                KFImage(URL(string: image))
                    .resizable()
                    .scaledToFill()
                    .frame(height: 227)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .clipped()
                    
                Text(author)
                    .font(.system(size: 14))
                
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 10).stroke(color, lineWidth: 2)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 10).fill(.white)
                    })
            }
        }
        .padding(.horizontal)
    }
}

struct PresentingCardView_Previews: PreviewProvider {
    static var previews: some View {
        PresentingCardView(color: .blue, title: "Title", description: "Description ajklsd ajsldkaljsd akjsldajmdl ajl ajlskdşaljsdkasd", image: "try1", author: "Berkay")
            .environmentObject(NavigationViewModel())
            .environmentObject(AuthViewModel())
    }
}
