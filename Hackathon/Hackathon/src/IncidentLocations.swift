//
//  IncidentLocations.swift
//  Hackathon
//
//  Created by Anthony Polka on 10/2/21.
//

import SwiftUI
import MapKit
import CoreData

struct PlaceAnnotationView: View {
    @State private var isShowing = false
    @State var incident: String
  var body: some View {
    VStack(spacing: 0) {
        Button(action: {
            withAnimation{
                isShowing.toggle()
            }
            
        }) {
           
            getIncidentImage(type: incident)
                .resizable()
                .scaledToFit()
                .frame(width: 30)
              .font(.title)
              .foregroundColor(getIncidentImageColor(type: incident))
              
              
        }
       
        if isShowing{
            Rectangle()
                .frame(width: 100, height: 50)
                .foregroundColor(Color.black)
                .background(Color.white)
                .border(Color.black, width: 1)
                .overlay(
                    Text(incident)
                        .padding()
                        .foregroundColor(Color.white)
                    
                )
        }
    }
    .preferredColorScheme(.light)
    
  }
}

struct ParkLocation: Identifiable{
    var id = UUID()
    var incident: String
    var coords: CLLocationCoordinate2D
    
}

struct IncidentLocations: View {
    @EnvironmentObject var data: IncidentData
   
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest( entity: Report.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Report.incidentType, ascending: true)],
        animation: .default)
    
    private var reports: FetchedResults<Report>
    
    @StateObject var locationManager = LocationManager()
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 29.749907, longitude: -95.358421), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State private var locations: [ParkLocation] = []
    @State private var centerCoordinate = CLLocationCoordinate2D()
    let geofenceRegionCenter = CLLocationCoordinate2DMake(29.749907,-95.358421)
    var locationManager2 : CLLocationManager = CLLocationManager()
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: locations) { place in
            MapAnnotation(coordinate: place.coords) {
                PlaceAnnotationView(incident: place.incident )
                  
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 100, identifier: "notifymeonExit")
            geofenceRegion.notifyOnExit = true
            geofenceRegion.notifyOnEntry = false
            locationManager2.startMonitoring(for: geofenceRegion)
            for i in reports {
                
               
                let newLocation = MKPointAnnotation()
                newLocation.coordinate.latitude = Double(i.longitude ?? "") ?? 0
                newLocation.coordinate.longitude = Double(i.latitude ?? "") ?? 0
                self.locations.append(ParkLocation(incident: i.incidentType ?? "", coords: newLocation.coordinate))
                //self.locations.append(newLocation)
            }
        }
    }
}

struct IncidentLocations_Previews: PreviewProvider {
   
    static var previews: some View {
        
        IncidentLocations()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(IncidentData())
    }
}

extension PlaceAnnotationView {
    func getIncidentImage(type: String) -> Image {
        switch type {
        case "Spill":       return Image(systemName: "drop.triangle.fill")
        case "Injury":      return Image(systemName: "waveform.path.ecg")
        case "Fire":        return Image(systemName: "flame.fill")
        case "Gas leak":    return Image(systemName: "smoke.fill")
        default: return Image(systemName: "photo.fill")
        }
    }
    func getIncidentImageColor(type: String) -> Color {
        switch type {
        case "Spill":       return .blue
        case "Injury":      return .red
        case "Fire":        return .orange
        case "Gas leak":    return .green
        default: return .yellow
        }
    }
}
