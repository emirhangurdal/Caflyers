//
//  Flyer.swift
//  Caflyers
//
//  Created by Emir Gurdal on 19.02.2024.
//

import SwiftUI


struct Flyer: View {
    
    @State private var isPageControlHidden = false
    @State private var isFullscreen = Bool()
    @ObservedObject var theFlyer = ThisFlyer()
    @Environment(\.presentationMode) var presentationMode
    @State var isFavorite = Bool()
    var cat = String()
    var brand = String()
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .orange
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.orange.withAlphaComponent(0.2)
        UIPageControl.appearance().backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    var body: some View {
        
        if #available(iOS 14, *) {
            ZStack {
                if theFlyer.flyer != nil {
                    VStack {
                        Text("\(theFlyer.flyer?[0].name ?? "")")
                            .font(.headline)
                        TabView() {
                            ForEach(theFlyer.flyer!, id: \.self) { flyer in
                                VStack {
                                    FlyerView(imageUrl: flyer.image_url, flyer: theFlyer.flyer)
                                    Text("\(flyer.id!)")
                                        .font(.headline)
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isPageControlHidden ? .never : .always))
                        .onAppear {
                            
                            setupAppearance()
                        }
                        .onTapGesture(count: 2) {
                            withAnimation {
                                isFullscreen.toggle()
                            }
                        }
                        .onTapGesture(count: 1) {
                            withAnimation {
                                isPageControlHidden.toggle()
                            }
                        } //: TABVIEW
                        .navigationBarTitleDisplayMode(.inline)
                        Text("\(theFlyer.flyer?[0].description ?? "")")
                            .font(.headline)
                            .padding(5)
                    }
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            HStack {
                                Button(action: {
                                    
                                }) {
                                    Image(uiImage: UIImage(named: self.isFavorite == true ? "icons8-favorite-60-filled" : "icons8-favorite-60")!)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                Spacer()
                                Button(action: {
                                    
                                }) {
                                    Image(uiImage: UIImage(named: "icons8-share-60")!)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                            }
                        }
                    }
                } else {
                    VStack(spacing: 10) {
                        ProgressView()
                        Text("Just a sec")
                    }
                }
                
            }
            .onAppear {
                theFlyer.loadData(cat: cat, brand: brand)
                
                let favoritesSaved = UserDefaults.standard.object(forKey: "Favorites") as? [String]
                if favoritesSaved?.contains(brand) == true {
                    isFavorite = true
                }
                
            }
            
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    if let aflyer = theFlyer.flyer {
                        ForEach(aflyer) { flyer in
                            FlyerView(imageUrl: flyer.image_url, flyer: aflyer)
                        }
                    }
                }
            }
        }
    }
}


extension FlyerView {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        
        if condition {
            transform(self)
        } else {
            self
        }
        
    }
}
