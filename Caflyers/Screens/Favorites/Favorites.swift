//
//  Favorites.swift
//  Caflyers
//
//  Created by Emir Gurdal on 15.04.2024.
//

import SwiftUI

struct Favorites: View {
    @ObservedObject var favoritesObservable = FavoritesObservable()
    
    var body: some View {
        Text("Favorites!")
    }
}


