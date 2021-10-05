//
//  IncidentReportsView.swift
//  Hackathon
//
//  Created by Anthony Polka on 10/3/21.
//

import SwiftUI

struct IncidentReports: View {
    @EnvironmentObject var data: DisplayData
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest( entity: Report.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Report.incidentType, ascending: true)],
        animation: .default)
    private var reports: FetchedResults<Report>
    var backgroundColor = LinearGradient(colors: [Color(#colorLiteral(red: 0.4552846551, green: 0.01592451707, blue: 0.0186363291, alpha: 1)), Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))], startPoint: .bottom, endPoint: .top)
   @State var testData = [(day: "Mon", value: 20),
                      (day: "Tue", value: 10),
                      (day: "Wed", value: 30),
                      (day: "Thu", value: 8),
                      (day: "Fri", value: 19),
                      (day: "Sat", value: 7),
                      (day: "Sun", value: 5)]
    
    @State var value = 0
    @State var low: Double = 0
    @State var num: Double = 0
    @State var day: String = "day"
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                Rectangle()
                    .frame(width: 400, height: 250)
                    .foregroundColor(Color.white)
                    .cornerRadius(25)
                    .shadow(radius: 20)
                    .overlay(
                       GraphLines()
                            .overlay(DrawMaxLine())
                            .overlay(drawLines())
                            .overlay(drawCicles())
                            .padding(20)
                    )
                    .padding(.top, 100)
                
                HStack{
                    Text("Incident Type")
                        .padding(.leading)
                    Spacer()
                    Text("person(s) involved")
                        .padding(.trailing)
                }
                ScrollView {
                    VStack {
                       
                        ForEach(reports, id: \.self) { report in
                            
                            IncidentCell(incidentType: report.incidentType ?? "",
                                         persons: report.persons ?? "",
                                         timeStamp: report.timestamp ?? Date(),
                                         info: report.incidentReport ?? "")
                        }
                    }
                }
            }
        }
        
        .preferredColorScheme(.light)
        .background(backgroundColor)
        .ignoresSafeArea()
        .sheet(isPresented: $data.isSelected, onDismiss: didDismiss) {
            VStack{
                Text(data.incidentType)
                    .font(.title)
                Text(data.time, formatter: itemFormatter)
                    .font(.subheadline)
                Text(data.persons)
                    .font(.system(size: 20))
                
                Text(data.description)
                    .font(.title)
                    .padding()
                    .border(Color.black, width: 1)
            }
            
              
        }
        
    }
    
    


func didDismiss() {
        // Handle the dismissing action.
    }
    
    func drawCicles() -> some View {
        GeometryReader { geo in
            let maxValue = testData.reduce(0) {(res, log) -> Double in
                return max(res, Double(log.value) + 5)
            }
            let scale = geo.size.height/CGFloat(maxValue)
            
            ForEach(0..<7) { i in
                Circle()
                    .stroke(Color.red, lineWidth: 5)
                    
                    .frame(width: 10, height: 10)
                    .background(Color.white)
                    .cornerRadius(5)
                    .offset(x: geo.size.width/8 + ((geo.size.width) / 8) * CGFloat(i) - 5, y: (geo.size.height - (CGFloat(testData[i].value) * scale)) - 5)
                    .onTapGesture{
                        value = testData[i].value
                        day = testData[i].day
                    }
                
            }
        }
    }
    func DrawMaxLine() -> some View {
        GeometryReader { geo in
            Path { path in
                let maxValue = testData.reduce(0) { (res, log) -> Double in
                    return max(res, Double(log.value))
                  
                }
                path.move(to: CGPoint(x: 0, y: maxValue))
                path.addLine(to: CGPoint(x: geo.size.width, y: maxValue))
                
            
                
            }.stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
            Path { path in
                let maxValue = testData.reduce(0) { (res, log) -> Double in
                    return max(res, Double(log.value))
                  
                }
                var newArray: [Double] = []
                let scale = geo.size.height / CGFloat(maxValue)
                for i in 0..<7 {
                    newArray.append(Double(testData[i].value))
                }
                let minValue = newArray.min() ?? 1
                low = minValue
                    path.move(to: CGPoint(x: 0, y: geo.size.height - minValue * scale + minValue))
                path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height - minValue * scale + minValue))
                
            }.stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
        }
    }
    func drawLines() -> some View {
        
        GeometryReader { geo in
            VStack{
            Path { path in
                
                let maxValue = testData.reduce(0) { (res, log) -> Double in
                    return max(res, Double(log.value) + 5)
                }
                let scale = geo.size.height/CGFloat(maxValue)
                var index: CGFloat = 0
                path.move(to: CGPoint(x: geo.size.width/8, y: geo.size.height - (CGFloat(testData[Int(index)].value)*scale)))
               
                
                for _ in testData {
                    if index != 0 {
                        path.addLine(to: CGPoint(x: geo.size.width/8 + ((geo.size.width)/8) * index, y: geo.size.height - CGFloat(testData[Int(index)].value) * scale))
                     
                    
                    }
                    index += 1
                }
                    
            }.stroke(Color.black, lineWidth: 1)
                    
            }
        }
    }
    
    func GraphLines() -> some View {
        GeometryReader { geo in
            HStack{
                Spacer()
                Text("\(day): \(value)")
                Spacer()
            }
            .offset(x: 0, y: -20)
            VStack(spacing: -1){
                Color.black
                    .frame(width: geo.size.width, height: 1)
            Path { path in


                let horizontalSpacing: CGFloat = geo.size.width/8
                let numberOfVerticalGridLines = 8

                for index in 0...numberOfVerticalGridLines {

                    let vOffset: CGFloat = CGFloat(index) * horizontalSpacing
                    path.move(to: CGPoint(x: vOffset, y: 0))
                    path.addLine(to: CGPoint(x: vOffset, y: geo.size.height))

                }

            } .stroke()
                Color.black
                    .frame(width: geo.size.width, height: 1)
                
                
            }
            HStack{
                Color.clear
                    .frame(width: geo.size.width/12, height: 0)
                ForEach(0..<7) { i in
                    let vOffset: CGFloat = CGFloat(i) * geo.size.width/geo.size.width
                    Text(testData[i].day)
                        .position(x: vOffset , y: 220)
                   
                }
               Spacer()
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


struct GraphView2_Previews: PreviewProvider {
    static var previews: some View {
        IncidentReports()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(DisplayData())
            
    }
}

