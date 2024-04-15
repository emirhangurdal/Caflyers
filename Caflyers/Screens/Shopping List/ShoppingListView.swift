//
//  ShoppingListView.swift
//  Caflyers
//
//  Created by Emir Gurdal on 5.04.2024.
//

import SwiftUI

struct ShoppingListView: View {
    let image: UIImage?
    let item: String?
    var body: some View {
        HStack(spacing: 10) {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .frame(width: 25, height: 25)
                Text(item ?? "")
            } else {
                ProgressView()
                Text(item ?? "")
            }
        }
    }
}


