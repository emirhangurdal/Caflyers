//
//  FlyerViewModel.swift
//  Caflyers
//
//  Created by Emir Gurdal on 23.02.2024.
//

import Foundation
import SwiftUI

class ThisFlyer: ObservableObject {
    @Published var flyer: [FlyerModel]? // @Published notifies the view when it changes (once network call is done)
    let caflyersAPI = CaflyersAPI()
    let endpoints = Endpoints()
    let parse = Parse()
    
    func loadData(cat: String, brand: String) {
        guard let url = endpoints.flyerUrl(cat: cat, brand: brand) else {return}
        
        caflyersAPI.getData(url: url) { data in
                
                self.parse.parseJson(data: data) { (flyer: [FlyerModel]) in
                    DispatchQueue.main.async {
                        self.flyer = flyer
                        
                    }
                }
        }
    }
}
