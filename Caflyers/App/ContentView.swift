
import SwiftUI

struct ContentView: View {
    let caflyersAPI = CaflyersAPI()
    let endPoints = Endpoints()
    let parse = Parse()
    @State private var selection = 1
    @ObservedObject var flyerBrandsViewModel = FlyerBrandObservable()

    var body: some View {
        TabView(selection: $selection) {
            Favorites()
                .tabItem {
                    Image(uiImage: UIImage(named: "icons8-heart-35")!)
                    Text("Favorites")
                }
            WeeklyFlyers(flyerBrandsViewModel: flyerBrandsViewModel)
                .tabItem {
                    Image(uiImage: UIImage(named: "icons8-paper-35")!)
                    Text("Flyers")
                }
                .tag(2)
            ShoppingList()
                .tabItem {
                    Image(uiImage: UIImage(named: "icons8-shopping-list-35")!)
                    Text("Shopping List")
                }
                .tag(3)
            
            StoreLocator(flyerBrandsViewModel: flyerBrandsViewModel)
                .tabItem {
                    Image(uiImage: UIImage(named: "icons8-maps-35")!)
                    Text("Map")
                }
                .tag(4)
        }//:TABVIEW
        .onAppear {
            flyerBrandsViewModel.loadData()
        }
        
    }
    
}


