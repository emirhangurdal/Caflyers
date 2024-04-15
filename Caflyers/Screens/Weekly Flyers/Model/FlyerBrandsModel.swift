//
//  FlyerBrands.swift
//  Caflyers
//
//  Created by Emir Gurdal on 17.02.2024.
//

import Foundation

struct FlyerBrandModel: Codable, Hashable, Identifiable {
    var id: Int?
    let image: String? //"https://www.caflyers.ca/resize/300/flyers_canadian-tire_on_mar-1-2024_0.jpg",
    let name: String? //Canadian Tire
    let valid: String? //March 1 2024-March 7 2024
    let brand: String? //canadian-tire
    let cat: String? //on-mar-1-2024
}
