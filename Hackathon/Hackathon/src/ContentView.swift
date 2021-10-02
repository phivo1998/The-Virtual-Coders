//  ContentView.swift
//  Hackathon
//
//  Created by Anthony Polka on 10/2/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var username = ""
    @State private var password = ""
    @State private var loggedin = false
    var gradient1 = LinearGradient(colors: [Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))], startPoint: .bottom, endPoint: .top)
    var body: some View {
        
        NavigationView{
            ZStack{
                Color(UIColor.systemGray3)
                    .ignoresSafeArea()
            VStack {
                
                Image(systemName: "photo.fill")
                    .resizable()
                    .foregroundColor(Color.black)
                    .background(gradient1)
                    .scaledToFit()
                    .frame(width: 100)
                    .clipShape(Circle())
                    
                    .shadow(radius: 10)
                Text("Login")
                    .font(.title)
                //MARK: username textfield
                TextField("Username", text: $username )
                    .font(.system(size: 20))
                    .padding()
                    .frame(width: 300, height: 50)
                    .border(Color.black, width: 2)
                
                //MARK: password textfield
                TextField("Password", text: $password)
                    .font(.system(size: 20))
                    .padding()
                    .frame(width: 300, height: 50)
                    .border(Color.black, width: 2)
                //MARK: check button
                NavigationLink(destination: {
                    MainView()
                }) {
                  
                        Text("Enter")
                            .font(.system(size: 25))
                            .foregroundColor(Color.black)
                            .padding()
                            .frame(width: 100, height: 40)
                            .border(Color.black, width: 1)
                            .background(gradient1)
                    
                }
            }
           
            if loggedin {
                
                
            }
            }
           
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
