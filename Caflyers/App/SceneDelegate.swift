
import Foundation
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView()
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let hostingController = UIHostingController(rootView: contentView)
            hostingController.view.frame = windowScene.coordinateSpace.bounds
            window.rootViewController = hostingController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

