//
//  FlyerBrandsObservable.swift
//  Caflyers
//
//  Created by Emir Gurdal on 2.03.2024.
//

import Foundation
import SwiftUI

class FlyerBrandObservable: ObservableObject {
    @Published var flyerBrands: [FlyerBrandModel]? // @Published notifies the view when it changes (once network call is done)
    @Published var searchTerm = String()
    let caflyersAPI = CaflyersAPI()
    let endpoints = Endpoints()
    let parse = Parse()
    
    func loadData() {
         let url = endpoints.flyerBrandsUrl
        caflyersAPI.getData(url: url) { data in
            self.parse.parseJson(data: data) { (flyerBrands: [FlyerBrandModel]) in
                DispatchQueue.main.async {
                    print("flyerBrands.count: \(flyerBrands.count)")
                    self.flyerBrands = flyerBrands
                }
            }
        }
    }
    
    func filterFlyerBrands() -> [FlyerBrandModel]? {
            guard let brands = flyerBrands else { return nil }
            if searchTerm.isEmpty {
                return brands // If search term is empty, return all brands
            } else {
                // Filter brands based on the search term
                return brands.filter { brand in
                    let lowercasedSearchTerm = searchTerm.lowercased()
                    return (brand.name?.lowercased().contains(lowercasedSearchTerm) ?? false)
                }
            }
        }
}
