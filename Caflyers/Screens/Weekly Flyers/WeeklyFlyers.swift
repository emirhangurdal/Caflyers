//
//  ContentView.swift
//  Caflyers
//
//  Created by Emir Gurdal on 17.02.2024.
//

import SwiftUI
struct WeeklyFlyers: View {
    @State private var isShowingCategories: Bool = false
    @State private var flyerBrands = [FlyerBrand]()
    let caflyersAPI = CaflyersAPI()
    let endpoints = Endpoints()
    let parse = Parse()
    var body: some View {
        NavigationView {
            if #available(iOS 14, *) {
                Text("Reconfigure for >iOS14")
            } else {
                    List() {
                        ForEach(flyerBrands, id: \.self) { flyerBrands in
                            HStack {
                                
                                FlyerBrandView(flyerBrand: flyerBrands)
                                Spacer()
                            }
                        }
                    }
                    .navigationBarTitle("Weekly Flyers", displayMode: .large)
                    .navigationBarItems(
                        leading:
                            Button(action: {
                            isShowingCategories = true
                        }, label: {
                            Image(systemName: "slider.horizontal.3")
                        }) //: CATEGORIES BUTTON
                            .sheet(isPresented: $isShowingCategories, content: {
                                FlyerCategories()
                            })
                    )
                    .onAppear {
                        caflyersAPI.getData(url: endpoints.flyerBrandsUrl) { data in
                            parse.parseJson(data: data) { (flyerbrands:[FlyerBrand]) in
                                print(flyerbrands)
                                flyerBrands = flyerbrands
                            }
                        }
                    } //LIST
            }
        } //NAVIGATION VIEW
    }
}


