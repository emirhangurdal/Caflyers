//
//  StoreLocator.swift
//  Caflyers
//
//  Created by Emir Gurdal on 19.02.2024.

import SwiftUI
import MapKit
import CoreLocation
import Combine

struct StoreLocator: View {
    @State private var isShowingFlyer: Bool = false

    // Search through flyerBrands.names to add annotation.
    // show closing hours/info when tapped to to annotation.
    @ObservedObject var flyerBrandsViewModel = FlyerBrandObservable()
    @ObservedObject var mapViewModel = MapObservable()
    
    var flyers = [FlyerBrandModel]()
    var region = MKCoordinateRegion()
    @State var aStore = "Metro"
    @State var postalCode = "M5V 1J9"
    @State var annotationImage: UIImage?
    init(flyerBrandsViewModel: FlyerBrandObservable) {
        print("ChatGPT it is not nil here: \(flyerBrandsViewModel.flyerBrands)")
        if flyerBrandsViewModel.flyerBrands != nil {
            self.flyers = flyerBrandsViewModel.flyerBrands!
        }
        mapViewModel.coordinates(fromZipCode: postalCode) {
            // Update the map region after coordinates are fetched
            
        }
        
    }
  
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                HStack {
                    TextField("Enter a Zip Code", text: $postalCode)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if !postalCode.isEmpty {
                        Button(action: {
                            postalCode = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                }
                
                HStack(spacing: 5) {
                    
                    TextField("Search a Store Brand", text: $aStore)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if !aStore.isEmpty {
                        Button(action: {
                            aStore = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                    Button {
                        mapViewModel.coordinates(fromZipCode: postalCode) {
                            mapViewModel.annotations.removeAll()
                            mapViewModel.searchForPlaces(searchTerm: aStore, flyerBrands: flyers)
                            UIApplication.shared.endEditing()
                        }
                    } label: {
                        
                            Image(uiImage: UIImage(named: "icons8-magnifying-glass-150")!)
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    
                    .padding()
                }
                
                Map(coordinateRegion: $mapViewModel.region, annotationItems: mapViewModel.annotations) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate!) {
                        if annotation.image != nil {
                            
                            VStack(spacing: 10) {
                                Image(uiImage: annotation.image!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 50)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: 25/10))
                                    .shadow(radius: 10)
                                Text("\(annotation.name!) Flyer")
                                    .font(.headline)
                                    .fontWeight(.heavy)
                                Text("\(annotation.date!)")
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                            }
                            .onTapGesture {
                                isShowingFlyer = true
                            }
                            .sheet(isPresented: $isShowingFlyer) {
                                Flyer(cat: annotation.cat!, brand: annotation.brand!)
                            }
                        }
                    }
                    
                } //: MAP
                .gesture(
                    TapGesture()
                        .onEnded({ _ in
                            print("Tapped")
                            UIApplication.shared.endEditing()
                        })
                       
                )
                
            } //:VStack
            .modifier(NavBarHidenViewModifier(isTitleVisible: false))
//            .gesture(
//                TapGesture()
//                    .onEnded({ _ in
//                        print("Tapped")
//                        UIApplication.shared.endEditing()
//                    })
//            )
        }
        
        
    }
}


extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}
