//
//  FlyerView.swift
//  Caflyers
//
//  Created by Emir Gurdal on 21.02.2024.
//

import SwiftUI


struct FlyerView: View {
    @State private var image: UIImage?
    @State private var scale: CGFloat = 1.0
    @State private var scale2: CGFloat = 1.0
    @State private var isAnimating = false
    
    var imageUrl: String?
    var flyer: [FlyerModel]?
    var body: some View {
        VStack(spacing: 5) {
            if image != nil {
                
                ZoomableScrollView(scale: $scale) {
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFit()
                }
                .gesture(
                    TapGesture(count: 2)
                        .onEnded({ value in
                            withAnimation {
                                if scale < maxAllowedScale / 2 {
                                    scale = maxAllowedScale
                                } else {
                                    scale = 1.0
                                }
                            }
                        })
                )

            } else {

                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading")
                }
            }

        }.onAppear {
                downloadImage(from: imageUrl!) { response in
                        image = response.image
                }
        }
    }
}





