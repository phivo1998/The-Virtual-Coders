//
//  IncidentData.swift
//  Hackathon
//
//  Created by Anthony Polka on 10/2/21.
//

import Foundation

class IncidentData: ObservableObject {
    @Published var isSelected = false
    @Published var incidentType = ""
    @Published var persons = [String]()
    @Published var description = ""
}
