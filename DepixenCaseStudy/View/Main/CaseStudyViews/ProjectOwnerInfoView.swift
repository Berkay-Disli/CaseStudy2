//
//  ProjectOwnerInfoView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 7.03.2023.
//

import SwiftUI
import Kingfisher

struct ProjectOwnerInfoView: View {
    let picUrl = URL(string: "https://avatars.githubusercontent.com/u/98886440?v=4")
    let githubLink = URL(string: "https://github.com/Berkay-Disli")
    let linkedInLink = URL(string: "https://www.linkedin.com/in/berkaydisli/")
    let instagramLink = URL(string: "https://www.instagram.com/iosdev22/")
    let email = "berkay.dsli@gmail.com"
    let resumeLink = URL(string: "https://drive.google.com/file/d/1_6wMRnNwRAQpaVMKb7bp1qGatpdBYHiJ/view?usp=sharing")
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(spacing: 20) {
                        KFImage(picUrl)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(Color("pri"), lineWidth: 2)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Berkay Dişli")
                                .font(.title)
                                .fontWeight(.medium)
                            
                            Text("iOS Developer")
                                .font(.title3)
                                .foregroundColor(.gray)
                            
                        }
                    }
                    
                }
                
                Section {
                    if let githubLink, let linkedInLink, let instagramLink {
                        Link(destination: linkedInLink) {
                            Label {
                                Text("LinkedIn Profile")
                                    .foregroundColor(.black)
                            } icon: {
                                Image("inIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 19)
                            }
                        }
                        Link(destination: githubLink) {
                            Label {
                                Text("GitHub Portfolio")
                                    .foregroundColor(.black)
                            } icon: {
                                Image("githubIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 19)
                            }
                        }
                        Link(destination: instagramLink) {
                            Label {
                                Text("Instagram Portfolio")
                                    .foregroundColor(.black)
                            } icon: {
                                Image("instaIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 19)
                            }

                        }
                        Label {
                            Text(verbatim: "berkay.dsli@gmail.com")
                        } icon: {
                            Image(systemName: "envelope")
                                .foregroundColor(.black)
                        }
                    }
                } header: {
                    Text("LINKS")
                }

                if let resumeLink {
                    Section {
                        HStack {
                            
                            Image("resumeIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                            
                            Link(destination: resumeLink) {
                                Text("See My Resume")
                                    .font(.title3)
                                    .foregroundColor(.black)
                            }
                        }
                    } header: {
                        Text("RESUME")
                    }
                }

                
            }
        }
        .navigationTitle("Project Owner")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProjectOwnerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectOwnerInfoView()
    }
}
