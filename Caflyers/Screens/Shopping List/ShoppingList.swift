//
//  ShoppingList.swift
//  Caflyers
//
//  Created by Emir Gurdal on 5.04.2024.
//

import SwiftUI
import Combine

struct ShoppingList: View {
    @State private var isScrolling = false
    @ObservedObject var shoppingListObserved = ShoppingListObservable()
    @State var newItemTitle = String()
    @State var newItemImage = UIImage()
    
    
    var body: some View {
        NavigationView {
            List {
                let shoppinglist = shoppingListObserved.shoppingList
                ForEach(shoppinglist) { shoppingItem in
                    HStack {
                        ShoppingListView(image: UIImage(named: shoppingItem.image!), item: shoppingItem.title)
                        Spacer()
                        Button(action: {
                            shoppingListObserved.deleteItem(item: shoppingItem)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
                .modifier(ScrollStatusMonitorExclusionModifier(isScrolling: $isScrolling))
                VStack(spacing: 10) {
                    TextField("Add Item", text: $newItemTitle)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        shoppingListObserved.addItem(title: newItemTitle, image: "icons8-grocery-80")
                        newItemTitle = ""
                    })
                    {
                        Image(uiImage: UIImage(named: "icons8-add-80")!)
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                .onChange(of: isScrolling, perform: { newValue in
                    UIApplication.shared.endEditing()
                })
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal, content: {
                    HStack {
                        Image(uiImage: UIImage(named: "caflayers_logo")!)
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("Shopping List").font(.headline)
                    }
                })
            }
        }
    }
}



final class ExclusionStore: ObservableObject {
    @Published var isScrolling = false
    // When the Runloop is in the default (kCFRunLoopDefaultMode) mode, a time signal will be sent every 0.1 seconds.
    private let idlePublisher = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
    // When the Runloop is in the tracking (UITrackingRunLoopMode) mode, a time signal will be sent every 0.1 seconds.
    private let scrollingPublisher = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    
    private var publisher: some Publisher {
        scrollingPublisher
            .map { _ in 1 } // Send 1 when scrolling
            .merge(with:
                    idlePublisher
                .map { _ in 0 } // Send 0 when not scrolling
            )
    }
    
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { output in
                guard let value = output as? Int else { return }
                if value == 1,!self.isScrolling {
                    self.isScrolling = true
                }
                if value == 0, self.isScrolling {
                    self.isScrolling = false
                }
            })
    }
}

struct IsScrollingKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isScrolling: Bool {
        get { self[IsScrollingKey.self] }
        set { self[IsScrollingKey.self] = newValue }
    }
}

struct ScrollStatusMonitorExclusionModifier: ViewModifier {
    @StateObject private var store = ExclusionStore()
    @Binding var isScrolling: Bool
    func body(content: Content) -> some View {
        content
            .environment(\.isScrolling, store.isScrolling)
            .onReceive(store.$isScrolling) { value in
                           guard value != isScrolling else { return }
                           isScrolling = value
                           print("isscrolling")
                       }
            .onDisappear {
                store.cancellable = nil // Prevent memory leaks
            }
    }
}
