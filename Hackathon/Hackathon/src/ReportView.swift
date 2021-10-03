//
//  ReportView.swift
//  Hackathon
//
//  Created by Anthony Polka on 10/2/21.
//

import SwiftUI

import FirebaseDatabase

import CoreData


struct ReportView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest( entity: Report.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Report.incidentType, ascending: true)],
        animation: .default)
    
    private var reports: FetchedResults<Report>
    
    @EnvironmentObject var data: IncidentData
    @StateObject var locationManager = LocationManager()
    @State private var incedentTypeSlected = false
    @State private var incidentPicked = ""
    @State private var personsField = ""
    @State private var incidentDescription = ""
    @State private var confirm = false
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var incidentType = ["Spill", "Injury", "fire", "gas leak"]
    var backgroundColor = LinearGradient(colors: [Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)), Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))], startPoint: .bottom, endPoint: .top)
    var body: some View {
        GeometryReader { geo in
            
            VStack{
                HStack{
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .padding()
                        .foregroundColor(Color.yellow)
                        .background(Color.black)
                        .clipShape(Circle())
                        .padding()
                       
                        
                    Text("Incident Report")
                        .font(Font.title.bold())
                        .padding()
                    Spacer()
                }
            Rectangle()
                    .frame(height: 1)
                //MARK: incident type
                Button(action: {
                    withAnimation {
                        data.isSelected.toggle()
                        incedentTypeSlected.toggle()
                        
                        
                    }
                }) {
                    VStack{
                        HStack{
                            
                            Text(data.incidentType.isEmpty ? "Incident type" : data.incidentType)
                                .font(.system(size: 20))
                                .padding()
                                .foregroundColor(data.incidentType.isEmpty ? .gray : .black)
                            
                            Spacer()
                                Image(systemName: "chevron.forward.circle")
                                .foregroundColor(Color.black)
                                .padding()
                                .rotationEffect(.degrees(incedentTypeSlected ? 90 : 0))
                            
                            }
                        .frame(width: 220)
                        .background(Color.white)
                        .shadow(radius: 10)
                        .border(Color.black, width: 1)
                            }
                        }
                .zIndex(2)
                if data.isSelected {
                    IncidentSelection()
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut)
                        .zIndex(1)
                   
                }
              
                TextField("Persons Involved", text: $personsField)
                    .font(.system(size: 20))
                    .padding()
                    .background(Color.white)
                    .frame(width: 220)
                    .border(Color.black, width: 1)
                    .shadow(radius: 10)
                Text("separated list by commas")
                
               Rectangle()
                    .frame(height: 1)
                
                Text("Incident Description")
                
                TextEditor(text: $incidentDescription)
                    .frame(width: 300, height: 200)
                    .border(Color.black, width: 1)
               
                
                HStack {
                    //MARK: send report button
                    Button(action: {
                        data.persons = splitNames(names: self.personsField)
                        data.description = incidentDescription
                        self.confirm = true
                    
                    }) {
                        Text("Report")
                            .font(.system(size: 20))
                            .padding()
                            .frame(width: 100, height: 30)
                            .foregroundColor(Color.black)
                            .background(Color.green)
                            .border(Color.black, width: 1)
                            .shadow(radius: 5)
                            
                    }
                    
                    //MARK: cancel report
                    Button(action: {}) {
                        Text("Cancel")
                            .font(.system(size: 20))
                            .padding()
                            .frame(width: 100, height: 30)
                            .foregroundColor(Color.black)
                            .background(Color.red)
                            .border(Color.black, width: 1)
                            .shadow(radius: 5)
                            
                    }
                }
            }
            .padding(.top, 70)
            //MARK: Confirm report popup
            .alert(isPresented: $confirm) {
                Alert(title: Text("Confirm"),
                      message: Text("Confirm your report"),
                      primaryButton: .default(Text("Accept"), action: {

                    print(data.incidentType)
                    print(data.persons)
                    print(data.description)
                    //Add Items to database as a report with unique Identifier
                    database.child("TotalIncidents").getData(completion: {error, snapshot in guard error == nil else{
                        print(error!.localizedDescription)
                        return;
                    }

                    let incidentNum = snapshot.value +1;
                    })
                    let object:[String: Any] = [
                        "incidentNum": incidentNum    
                        "incidentType": data.incidentType
                        "persons":data.persons
                        "description": data.description
                    ]
                    database.child("Incident #\(incidentNum)").setValue(object)

                   addItem()
                    for i in reports {
                        print(i)
                    }
                    
                }),
                      secondaryButton: .destructive(Text("Cancel")))
            }
            
        }
        .preferredColorScheme(.light)
        .background(backgroundColor)
        .ignoresSafeArea()
    }
    private func addItem() {
        withAnimation {
            let newItem = Report(context: viewContext)
            //newItem.persons = data.persons
            newItem.timestamp = Date()
            newItem.incidentType = data.incidentType
            newItem.incidentReport = data.description
            newItem.longitude = "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
            newItem.latitude = "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}


struct IncidentSelection: View {
    @EnvironmentObject var data: IncidentData
    @State var selected = false
    @State var selection = ""
    var incidentType = ["Spill", "Injury", "fire", "gas leak"]
    var body: some View {
        VStack{
            ForEach(incidentType, id: \.self) { i in
                Button(action: {
                    withAnimation{
                    data.incidentType = i
                    data.isSelected = false
                        print(data.incidentType)
                    }
                    
                }) {
                    Text(i)
                        .font(.subheadline)
                }
                .padding(.all, 5)
                Divider()
            }
            
        }
        .frame(width: 220)
        .background(Color.white)
        .border(Color.black, width: 1)
      
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
            .environmentObject(IncidentData())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

extension ReportView {
    
    func splitNames(names: String) -> [String] {
        let splitNames = names.components(separatedBy: ",")
        return splitNames
    }
}

