//
//  FlyerCategories.swift
//  Caflyers
//
//  Created by Emir Gurdal on 19.02.2024.
//

import Foundation
import SwiftUI

struct FlyerCategories: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        List {
            ForEach(1..<6) { index in
                Text("A Category \(index)")
            }
        }
    }
}

