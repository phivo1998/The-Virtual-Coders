//
//  IncidentCell.swift
//  Hackathon
//
//  Created by Anthony Polka on 10/3/21.
//

import SwiftUI

struct IncidentCell: View {
    @EnvironmentObject var data: DisplayData
    var incidentType: String = "type"
    var persons: String = "John Doe"
    var textFont: Font = .system(size: 20)
    var timeStamp: Date = Date()
    @State private var isSelected = false
    var body: some View {
        HStack{
            Button(action: {
                
                data.isSelected = true
                data.persons = [self.persons]
                data.time = self.timeStamp
                data.incidentType = self.incidentType
                
                
            }) {
                VStack(alignment: .leading){
                    Text(incidentType)
                        .font(textFont)
                        .padding(.leading)
                    Text(timeStamp, formatter: itemFormatter)
                        .padding(.leading)
                }
                Spacer()
                Text(persons)
                    .font(textFont)
                    .padding(.trailing)
            }
            .foregroundColor(Color.black)
        }
        .preferredColorScheme(.light)
        .frame(width: 400, height: 50)
        .border(Color.black, width: 2)
        .background(Color.white)
        .shadow(radius: 10)
    }
}
                     
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct IncidentCell_Previews: PreviewProvider {
    static var previews: some View {
        IncidentCell().previewLayout(.sizeThatFits)
            .environmentObject(DisplayData())
    }
}
