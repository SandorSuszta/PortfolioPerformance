import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let services = Services(
            watchlistStore: WatchlistStore(),
            recentSearchesService: RecentSearchesStore()
        )
        
        let appCoordinator = AppCoordinator(
            window: window,
            tabBarController: PPTabBarController(),
            services: services
        )
        
        appCoordinator.start()
        
        self.window = window
    }
}
