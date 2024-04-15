//
//  FavoritesModel.swift
//  Caflyers
//
//  Created by Emir Gurdal on 15.04.2024.
//

import Foundation
import SwiftUI

class FavoritesObservable: ObservableObject {
    @Published var favoriteFlyers = [String]() // @Published notifies the view when it changes (once network call is done)
    
    func addToFavorites(brand: String) {
        favoriteFlyers.append(brand)
        UserDefaults.standard.set(favoriteFlyers, forKey: "Favorites")
    }
    func deleteFromFavorites(brand: String) {
        if let index = favoriteFlyers.firstIndex(of: brand) {
              favoriteFlyers.remove(at: index)
              UserDefaults.standard.set(favoriteFlyers, forKey: "Favorites")
          }
    }
    init() {
        if let favoriteFlyersSaved = UserDefaults.standard.data(forKey: "Favorites") as? [String] {
            favoriteFlyers = favoriteFlyersSaved
        }
    }
}
