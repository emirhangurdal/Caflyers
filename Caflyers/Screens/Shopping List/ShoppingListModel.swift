import Foundation
import UIKit
import SwiftUI

struct ShoppingListModel: Hashable, Identifiable, Codable {
    var id = UUID()
    let title: String?
    let image: String?
}

class ShoppingListObservable: ObservableObject {
    @Published var shoppingList: [ShoppingListModel] = []
    
    func addItem(title: String, image: String) {
        shoppingList.append(ShoppingListModel(title: title, image: image))
        saveList()
    }
    
    func deleteItem(item: ShoppingListModel) {
         if let index = shoppingList.firstIndex(where: { $0.id == item.id }) {
             shoppingList.remove(at: index)
             saveList()
         }
     }

     // Optional: You can also implement a function to delete multiple items at once
     func deleteItems(at offsets: IndexSet) {
         shoppingList.remove(atOffsets: offsets)
     }
    
    func saveList() {
            if let encodedList = try? JSONEncoder().encode(shoppingList) {
                UserDefaults.standard.set(encodedList, forKey: "ShoppingList")
            }
        }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "ShoppingList"),
           let decodedList = try? JSONDecoder().decode([ShoppingListModel].self, from: data) {
            shoppingList = decodedList
        }
    }
}
