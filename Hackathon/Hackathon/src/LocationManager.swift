//
//  LocationManager.swift
//  Hackathon
//
//  Created by Anthony Polka on 10/2/21.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unkown"
        }
        switch status {
        case .notDetermined: return "notDetermined"
                case .authorizedWhenInUse: return "authorizedWhenInUse"
                case .authorizedAlways: return "authorizedAlways"
                case .restricted: return "restricted"
                case .denied: return "denied"
                default: return "unknown"
        }
    }
    
}

