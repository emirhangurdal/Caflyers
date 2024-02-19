//
//  ContentView.swift
//  Caflyers
//
//  Created by Emir Gurdal on 19.02.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WeeklyFlyers()
                .tabItem {
                    Image(systemName: "book")
                    Text("Flyers")
                }
            StoreLocator()
                .tabItem {
                    Image(systemName: "map")
                    Text("Stores")
                }
        }//:TABVIEW
    }
}


