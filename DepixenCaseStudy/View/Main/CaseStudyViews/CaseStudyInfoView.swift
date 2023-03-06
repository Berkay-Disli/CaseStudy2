//
//  CaseStudyInfoView.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 7.03.2023.
//

import SwiftUI

struct CaseStudyInfoView: View {
    @EnvironmentObject var navVM: NavigationViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("This app is developed as a case study given from Depixen.\n\nIt demonstrates simple tasks such as creating a card and showing it in another view. However, since these kinds of projects are a perfect opportunity to showcase a developer's skillset, this app includes many other core features.")
                } header: {
                    Text("Info")
                }
                
                Section {
                    Group {
                        Label("Complex authentication system", systemImage: "chevron.left.forwardslash.chevron.right")
                        Label("Complex card post system", systemImage: "chevron.left.forwardslash.chevron.right")
                        Label("Showcase of all the cards and users", systemImage: "chevron.left.forwardslash.chevron.right")
                        Label("Custom UI views", systemImage: "chevron.left.forwardslash.chevron.right")
                        Label("Realtime database with Firebase", systemImage: "chevron.left.forwardslash.chevron.right")
                        Label("Asynchronous functions", systemImage: "chevron.left.forwardslash.chevron.right")
                        Label("Custom tab manager", systemImage: "chevron.left.forwardslash.chevron.right")
                        Label("Smooth animations", systemImage: "chevron.left.forwardslash.chevron.right")
                        Label("Alerts", systemImage: "chevron.left.forwardslash.chevron.right")
                    }
                    .foregroundColor(.black)
                } header: {
                    Text("Some other features")
                }
            }
            .listStyle(.grouped)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.25)) {
                    navVM.disableNavBar()
                }
            }
            .onDisappear {
                withAnimation(.easeInOut(duration: 0.25)) {
                    navVM.enableNavBar()
                }
            }
        }
        .navigationBarTitle("Depixen Case Study")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CaseStudyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CaseStudyInfoView()
            .environmentObject(NavigationViewModel())
    }
}
