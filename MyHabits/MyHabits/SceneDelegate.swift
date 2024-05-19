import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)

        // Отображение LaunchScreenView
        let launchScreenView = LaunchScreenView()
        let launchScreenVC = UIHostingController(rootView: launchScreenView)
        window.rootViewController = launchScreenVC
        self.window = window
        window.makeKeyAndVisible()

        // Переход на MainTabBarController через 2 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let mainTabBarController = MainTabBarController()
            window.rootViewController = mainTabBarController
            window.makeKeyAndVisible()
        }
    }
}
