//
//  PresentingCardView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 5.03.2023.
//

import SwiftUI

struct PresentingCardView: View {
    @EnvironmentObject var navVM: NavigationViewModel
    let color: Color
    let title: String
    let description: String
    let image: String
    @Binding var expandCard: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            RoundedRectangle(cornerRadius: 10).fill(color)
                .frame(width: 60, height: 30)
                .padding([.top, .leading]).padding(.leading)
                .offset(y: 20)
                
            
            
            RoundedRectangle(cornerRadius: 10).stroke(Color("pri"), lineWidth: 2)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10).fill(.white)
                        .padding(2)
                })
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .frame(height: 380)
                .padding(.horizontal).padding(.horizontal)
                .shadow(color: .gray, radius: 10, x: 0, y: 5)
                
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(title)
                                .font(.system(size: 30))
                                .fontWeight(.medium)
                                .foregroundColor(Color("pri"))
                                .padding([.leading, .top], 7)
                                .padding(.bottom, 4)
                                .frame(maxWidth: 300, alignment: .leading)
                                
                            
                            Button {
                                //withAnimation(.easeInOut) {
                                    expandCard = false
                                //}
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                            .padding(.trailing).padding(.vertical, 10)
                            

                        }
                            
                        
                        Rectangle().colorInvert()
                            .frame(height: 100)
                            .overlay(alignment: .topLeading, content: {
                                Text(description)
                                    .font(.system(size: 15))
                            })
                            .padding(.horizontal, 8)
                            
                            
                        Divider()
                            .padding(.vertical, 4)
                        
                        Image(image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            //.border(.red)
                            .clipped()
                            .hAlign(.center)
                            .padding(.top, 4)
                        
                        Text("author")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                            .vAlign(.center)
                            .hAlign(.center)
                            
                            
                            
                    }
                    .padding(.horizontal).padding(.horizontal)
                }
                
            
        }
    }
}

struct PresentingCardView_Previews: PreviewProvider {
    static var previews: some View {
        PresentingCardView(color: .pink, title: "Title", description: "Description", image: "try9", expandCard: .constant(true))
            .environmentObject(NavigationViewModel())
    }
}
