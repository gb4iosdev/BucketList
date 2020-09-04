//
//  ContentView.swift
//  BucketList
//
//  Created by Gavin Butler on 28-08-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import MapKit
import SwiftUI
import LocalAuthentication

enum ActiveAlert {
    case authenticationFailed, noBiometrics
}

struct ContentView: View {
    
    @State private var isUnlocked = false
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .authenticationFailed
    
    var body: some View {
        
        ZStack {
            if isUnlocked {
                MainMapView()
            } else {
                Button("Unlock Places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
            }
        }
        .alert(isPresented: $showAlert) {
            switch activeAlert {
            case .authenticationFailed:
                return Alert(title: Text("What the Face?"), message: Text("Your Face Not Recognized"), dismissButton: .default(Text("OK")))
            case .noBiometrics:
                return Alert(title: Text("Old Phone?"), message: Text("Biometrics not supported"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.activeAlert = .authenticationFailed
                        self.showAlert = true
                    }
                }
            }
        } else {
            self.activeAlert = .noBiometrics
            self.showAlert = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Using Touch ID and Face ID with SwiftUI
//Add Privacy - Useage Description row to Info.plist file for face ID.
/*import LocalAuthentication
import SwiftUI

struct ContentView: View {
    
    @State private var isUnlocked = false
    
    
    var body: some View {
        VStack {
            if self.isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, autenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        //  There was a problem
                    }
                }
            }
        } else {
            // No biometrics present on device
        }
    }
}*/

//Integrating MapKit (MapView) with SwiftUI
/*struct ContentView: View {
    
    var body: some View {
        MapView()
            .edgesIgnoringSafeArea(.all)
    }
}
 import MapKit
 import SwiftUI

 struct MapView: UIViewRepresentable {
     
     class Coordinator: NSObject, MKMapViewDelegate {
         var parent: MapView
         
         init(_ parent: MapView) {
             self.parent = parent
         }
         
         func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
             print(mapView.centerCoordinate)
         }
         
         func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
             let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
             view.canShowCallout = true
             return view
         }
     }
     
     func makeCoordinator() -> Coordinator {
         Coordinator(self)
     }
     
     func makeUIView(context: Context) -> MKMapView {    //"Context" is same as UIViewRepresentableContext<MapView>
         let mapView = MKMapView()
         mapView.delegate = context.coordinator
         
         let annotation = MKPointAnnotation()
         annotation.title = "London"
         annotation.subtitle = "Capital of England"
         annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: 0.13)
         mapView.addAnnotation(annotation)
         return mapView
     }
     
     func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
         
     }
 }*/

//Switching view states with enums:
/*struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}


struct ContentView: View {
    
    enum LoadingState {
        case loading, success, failed
    }
    
    var loadingState = LoadingState.loading
    
    var body: some View {
        Group {
            if loadingState == .loading {
                LoadingView()
            } else if loadingState == .success {
                SuccessView()
            } else if loadingState == .failed {
                FailedView()
            }
        }
    }
}*/

//Review Conditional Views:
/*struct ContentView: View {
    
    var body: some View {
        Group {
            if Bool.random() {
                Rectangle()
            } else {
                Circle()
            }
        }
    }
}*/

//Writing data to the documents directory using a FileManager extension and generics:
/*
 struct ContentView: View {
     
     var body: some View {
         Text("Hello")
             .onTapGesture {
                 FileManager.writeTo(content: "Testing Generics and writing", fileName: "Blah.txt")
                 print(FileManager.contentsOf(fileName: "Blah.txt"))
         }
     }
 }
 extension FileManager {
     static func getDocumentsDirectory() -> URL {
         let paths = self.default.urls(for: .documentDirectory, in: .userDomainMask)
         return paths[0]
     }
     
     static func writeTo<T: CustomStringConvertible>(content: T, fileName: String) {
         let url = self.getDocumentsDirectory()
         .appendingPathComponent(fileName)
         
         let contentToWrite = content.description
         
         do {
             try contentToWrite.write(to: url, atomically: true, encoding: .utf8)
         } catch {
             fatalError("Failed to write to: \(fileName) \(error.localizedDescription)")
         }
     }
     
     static func contentsOf(fileName: String) -> String {
         let url = self.getDocumentsDirectory()
         .appendingPathComponent(fileName)
         
         do {
             let contents = try String(contentsOf: url)
             return contents
         } catch {
             fatalError("Failed to read from: \(fileName) \(error.localizedDescription)")
         }
     }
 } */

//Writing data to the documents directory
/*struct ContentView: View {
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    var body: some View {
        Text("Hello")
            .onTapGesture {
                let str = "Test Message"
                let url = self.getDocumentsDirectory()
                .appendingPathComponent("message.txt")
                
                do {
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
        }
    }
}*/

//Sorting an array of structs by conforming to Comparable protocol
/*struct User: Identifiable, Comparable {
    
    let id = UUID()
    let firstName: String
    let lastName: String
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
    //'Greater than' conformance is handled by swift by reversing the above func
}


struct ContentView: View {
    
    let users = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Lister")
        ].sorted()
    
    var body: some View {
        List(users) { user in
            Text("\(user.firstName) \(user.lastName)")
        }
    }
}*/

//Sorting an array of structs using a closure
/*struct User: Identifiable, Comparable {
    
    let id = UUID()
    let firstName: String
    let lastName: String
}
struct ContentView: View {
    
    let users = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Lister")
        ].sorted {
            $0.lastName < $1.lastName
    }
    
    var body: some View {
        List(users) { user in
            Text("\(user.firstName) \(user.lastName)")
        }
    }
}*/
