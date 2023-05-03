import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let appCoordinator = AppCoordinator(
            window: window,
            tabBarController: UITabBarController(),
            watchlistStore: WatchlistStore(),
            recentSearchesStore: RecentSearchesStore()
        )
        
        appCoordinator.start()
        
        self.window = window
    }
}
