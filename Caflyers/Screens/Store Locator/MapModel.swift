//
//  MapModel.swift
//  Caflyers
//
//  Created by Emir Gurdal on 3.03.2024.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import Contacts


//MARK: Annotation Type
struct Market: Identifiable {
    let id = UUID()
    var name: String?
    var brand: String?
    var cat: String?
    var image: UIImage?
    var date: String?
    var coordinate: CLLocationCoordinate2D?
}

//MARK:  MapObservable
class MapObservable: ObservableObject {
    
    @Published var region = MKCoordinateRegion()
    var annotations = [Market]()
    let semaphore = DispatchSemaphore(value: 1)
    var uniqueCoordinates = Set<CLLocationCoordinate2D>()
    func coordinates(fromZipCode zipCode: String, completion: @escaping () -> Void) {
        let geocoder = CLGeocoder()
        let postalAddress = CNMutablePostalAddress()
        postalAddress.postalCode = zipCode
        geocoder.geocodePostalAddress(postalAddress) { placemark, error in
            
            guard let coordinates = placemark?.first?.location?.coordinate else {
                print("Error finding coordinates for postal code: \(error?.localizedDescription)")
                return
            }
            
            self.region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            completion()
            
        }
    }
    
    func searchForPlaces(searchTerm: String, flyerBrands: [FlyerBrandModel]) {
        let request = MKLocalSearch.Request()
        
        let filteredBrands = filterFlyerBrands(searchTerm: searchTerm, flyerBrands: flyerBrands)
        
        for flyerBrand in filteredBrands! {
            request.naturalLanguageQuery = searchTerm
            request.region = self.region
            
            let search = MKLocalSearch(request: request)
            guard ((flyerBrand.name?.containsIgnoringCase(find: searchTerm)) != nil) else {return}
                // wait for each request otherwise you'll get throttled.
                search.start { response, error in
                    
                    guard let response = response else {
                        print("Error searching for places:", error?.localizedDescription ?? "")
                        return
                    }
                    
                    response.mapItems.map { item in
                        guard let coordinate = item.placemark.location?.coordinate else {
                            return Market()// Skip if the coordinate is not available
                        }
                        
                        // Check if the coordinate is already present
                        guard self.uniqueCoordinates.insert(coordinate).inserted else {
                            // Coordinate already exists, skip adding the annotation
                            return Market()
                        }
                        
                        var annotation = Market(name: nil, brand: nil, cat: nil, image: nil, date: nil, coordinate: nil)
                        
                        annotation.coordinate = coordinate
                        annotation.name = flyerBrand.name
                        annotation.date = flyerBrand.valid
                        annotation.cat = flyerBrand.cat
                        annotation.brand = flyerBrand.brand
                        
                        DispatchQueue.main.async {
                            downloadImage(from: flyerBrand.image!) { response in
                                annotation.image = response.image
                                print("annotation: \(annotation)")
                                self.annotations.append(annotation)
                                
                            }
                        }
                        return annotation
                    }
                }
        
        }
}
    func filterFlyerBrands(searchTerm: String, flyerBrands: [FlyerBrandModel]?) -> [FlyerBrandModel]? {
        guard let brands = flyerBrands else { return nil }
        if searchTerm.isEmpty {
            
            return brands // If search term is empty, return all brands
        } else {
            // Filter brands based on the search term
            return brands.filter { brand in
                let lowercasedSearchTerm = searchTerm.lowercased()
                if brand.name?.lowercased().contains(lowercasedSearchTerm) == true {
                    print("data contains that term")
                } else {
                    print("data doesn't contain that term")
                }
                return (brand.name?.lowercased().contains(lowercasedSearchTerm) ?? false)
            }
        }
    }
}


extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }

    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}


