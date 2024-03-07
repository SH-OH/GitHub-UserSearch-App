import UIKit

import HomeFeatureInterface
import UserSearchFeatureInterface
import FavoriteSearchFeatureInterface

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        let factory = AppDelegate.container.resolve(HomeFactory.self)
        if let viewController = factory?.makeViewController() {
            navigationController.setViewControllers([viewController], animated: true)
            viewController.navigationItem.largeTitleDisplayMode = .always
        }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
