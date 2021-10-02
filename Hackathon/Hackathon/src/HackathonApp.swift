//
//  HackathonApp.swift
//  Hackathon
//
//  Created by Anthony Polka on 10/2/21.
//

import SwiftUI

@main
struct HackathonApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var data = IncidentData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(data)
        }
    }
}
