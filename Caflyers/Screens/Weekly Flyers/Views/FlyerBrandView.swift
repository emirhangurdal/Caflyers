//
//  FlyerBrandView.swift
//  Caflyers
//
//  Created by Emir Gurdal on 17.02.2024.
//

import Foundation
import SwiftUI

import SwiftUI
struct FlyerBrandView: View {
    var flyerBrand: FlyerBrandModel?
   
    @State private var image: UIImage?
    
    func retrieveFlyerBrandImage() {
       
        if flyerBrand != nil {
            downloadImage(from: flyerBrand?.image ?? "https://storage.caflyers.ca/theme/logo.png") { response in
                DispatchQueue.main.async {
                    image = response.image
                }
            }
        }
    }
    
    var body: some View {
        if #available(iOS 14, *) {
            VStack(spacing: 10) {
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150, alignment: .center)
//                        .clipShape(Circle())
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                } else {

                    VStack(spacing: 10) {
                        ProgressView()
                        Text("Loading")
                    }
                }
                Text(flyerBrand?.name ?? "???")
                    .font(.subheadline)
                    .fontWeight(.heavy)
                Text(flyerBrand?.valid ?? "???")
                    .font(.caption)
            }
            .onAppear {
                retrieveFlyerBrandImage()
            }
            
        } else {
            HStack {
                VStack(spacing: 10) {
                    if image != nil {
                        Image(uiImage: image!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            
                    } else {
                        Image(uiImage: UIImage(named: "PlaceHolderBrand")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    }
                    
                    Text(flyerBrand?.name ?? "???")
                        .font(.subheadline)
                        .fontWeight(.heavy)
                }
                .frame(width: 150, height: 150, alignment: .center)
                Text(flyerBrand?.valid ?? "???")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
            }
            .onAppear {
                retrieveFlyerBrandImage()
            }
        }
    }
}
