//
//  ContentView.swift
//  Caflyers
//
//  Created by Emir Gurdal on 17.02.2024.
//

import SwiftUI
import Combine

struct WeeklyFlyers: View {
    
    @State private var isShowingCategories: Bool = false
    @State private var searchText = ""
    @State private var flyerBrands: [FlyerBrandModel]?
    @State var searchTerm = String()
    @State var theFlyer = [FlyerModel]()
    @ObservedObject var flyerBrandsViewModel = FlyerBrandObservable()
    @State private var isTitleVisible = true

    let detector: CurrentValueSubject<CGFloat, Never>
    let publisher: AnyPublisher<CGFloat, Never>
    
    init(flyerBrandsViewModel: FlyerBrandObservable) {
            let detector = CurrentValueSubject<CGFloat, Never>(0)
            self.publisher = detector
                .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
                .dropFirst()
                .eraseToAnyPublisher()
            self.detector = detector
            self.flyerBrandsViewModel = flyerBrandsViewModel
        }
    
    @available(iOS 14.0, *)
    private var gridLayout: [GridItem] {
        return [GridItem(.flexible()), GridItem(.flexible())]
    }
    
    var body: some View {
        
        NavigationView {
            if #available(iOS 14, *) {
                GeometryReader { geo in
                    
                    VStack {
                        HStack {
                            TextField("Search", text: $flyerBrandsViewModel.searchTerm)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .opacity(isTitleVisible ? 1.0:0.5)
                            if !flyerBrandsViewModel.searchTerm.isEmpty {
                                Button(action: {
                                    flyerBrandsViewModel.searchTerm = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                }
                                .padding()
                            }
                        }
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                
                                if let filteredBrands = flyerBrandsViewModel.filterFlyerBrands() {
                                        LazyVGrid(columns: gridLayout, alignment: .center
                                                  , spacing: 10) {
                                            ForEach(filteredBrands, id: \.self) { flyerBrand in
                                                
                                                NavigationLink(destination: Flyer(cat: flyerBrand.cat!, brand: flyerBrand.brand!)
                                                   
                                                )
                                                {
                                                    FlyerBrandView(flyerBrand: flyerBrand)
                                                }
                                                .buttonStyle(.plain)
                                            }
                                            
                                        } //: GRID
                                                  .modifier(NavBarHidenViewModifier(isTitleVisible: isTitleVisible))
                                                  .navigationBarTitleDisplayMode(.inline)
                                                  .toolbar {
                                                      ToolbarItem(placement: .principal, content: {
                                                          HStack {
                                                              Image(uiImage: UIImage(named: "caflayers_logo")!)
                                                                  .resizable()
                                                                  .frame(width: 25, height: 25)
                                                              Text("Ca Flyers").font(.headline)
                                                          }
                                                      })
                                                  }
                                                  .background(GeometryReader {
                                                                  Color.clear.preference(key: ViewOffsetKey.self,
                                                                      value: -$0.frame(in: .named("scroll")).origin.y)
                                                              })
                                                  .onPreferenceChange(ViewOffsetKey.self) {
                                                      print($0)
                                                      UIApplication.shared.endEditing()
                                                      if $0 > 300.0 {
                                                          withAnimation(.easeOut(duration: 0.5)) {
                                                              isTitleVisible = false
                                                          }
                                                          
                                                      } else {
                                                          isTitleVisible = true
                                                      }
                                                      detector.send($0) }
                                    } else {
                                        ProgressView()
                                    }
                                
                                                                    
                            } //: SCROLL
                            .coordinateSpace(name: "scroll")
                            .onReceive(publisher) {
                                print("Stopped on: \($0)")
                                
                            }
                    } //: VSTACK
                  
                } //: GEOREADER
                .onDisappear(perform: {
                    
                })
                
            } else {
                if flyerBrandsViewModel.flyerBrands != nil {
                    List() {
                        ForEach(flyerBrandsViewModel.flyerBrands!, id: \.self) { flyerBrands in
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
                        flyerBrandsViewModel.loadData()
                    } //: LIST
                } else {
                   Text("An Error Occured")
                }
            }
        } //NAVIGATION VIEW
       
    }
}

struct NavBarHidenViewModifier: ViewModifier {
    var isTitleVisible = Bool()
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .toolbar(isTitleVisible ? .visible:.hidden, for: .navigationBar)
        } else {
            content
                .navigationBarHidden(!isTitleVisible)
        }
    }
}


