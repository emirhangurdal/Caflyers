//
//  FlyerBrands.swift
//  Caflyers
//
//  Created by Emir Gurdal on 17.02.2024.
//

import Foundation

struct FlyerBrand: Codable, Hashable, Identifiable {
    var id: Int?
    let image: String? //flyer's cover image
    let name: String? //brand name
    let valid: String?
    let brand: String? //brand slug
    let cat: String? //Date on
}
