//
//  IncidentData.swift
//  Hackathon
//
//  Created by Anthony Polka on 10/2/21.
//

import Foundation
import MapKit

struct Location: Identifiable {
    
    var id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

class IncidentData: ObservableObject {
    @Published var isSelected = false
    @Published var incidentType = ""
    @Published var persons = ""
    @Published var description = ""
    @Published var annotations: [Location] = []
}
class DisplayData: ObservableObject {
    @Published var isSelected = false
    @Published var incidentType = ""
    @Published var persons = ""
    @Published var description = ""
    @Published var annotations: [Location] = []
    @Published var time: Date = Date()
}
