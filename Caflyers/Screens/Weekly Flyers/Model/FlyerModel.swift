//
//  FlyerModel.swift
//  Caflyers
//
//  Created by Emir Gurdal on 19.02.2024.
//

import SwiftUI

struct FlyerModel: Codable, Identifiable, Hashable {
    let id: Int?
    let name: String? //Freshco
    let image_url: String?
    let count: String?
    let remaining: String? //Days Hours Left
    let description: String? //January 11 2024-January 17 2024
    let logo: String? //freshco.png
    let share_url: String? //freshco-flyer/on-jan-11-2024/
}


