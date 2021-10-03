//
//  MainView.swift
//  Hackathon
//
//  Created by Anthony Polka on 10/2/21.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest( entity: Report.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Report.incidentType, ascending: true)],
        animation: .default)
    
    private var reports: FetchedResults<Report>
    
    @EnvironmentObject var data: IncidentData
    init() {
        UITabBar.appearance().backgroundColor = UIColor.systemGray4
    }
    var body: some View {
        TabView{
            IncidentReports()
                .tabItem{
                    Label("Incident Reports", systemImage: "exclamationmark.bubble.fill")
                }
            IncidentLocations()
                .tabItem{
                    Label("Incident Report", systemImage: "location.fill.viewfinder")
                    
                }
            ReportView()
                .tabItem{
                    Label("Incident Report", systemImage: "exclamationmark.triangle.fill")
                    
                }
            
        }
        
        .preferredColorScheme(.light)
        .accentColor(.red)
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
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
