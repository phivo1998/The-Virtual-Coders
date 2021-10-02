//
//  MainView.swift
//  Hackathon
//
//  Created by Anthony Polka on 10/2/21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var data: IncidentData
    init() {
        UITabBar.appearance().backgroundColor = UIColor.systemGray4
    }
    var body: some View {
        TabView{
            ReportView()
                .tabItem{
                    Label("Incident Report", systemImage: "photo.fill")
                    
                }
              
       
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            UITabBar.appearance().barTintColor = .red
        }
        
    }
}
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(IncidentData())
    }
}
