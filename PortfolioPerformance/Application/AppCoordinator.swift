import UIKit

class AppCoordinator {
    
    var childCoordinators: [Coordinator] = []
    
    let window: UIWindow
    
    let tabBarController: UITabBarController
    
    let services: Services
    
    func startApp() {
        
        let marketCoordinator = MarketCoordinator(
            services: services,
            navigationController: UINavigationController()
        )
        
        let watchlistCoordinator = WatchlistCoordinator(
            navigationController: UINavigationController(),
            services: services)
        
        marketCoordinator.start()
        watchlistCoordinator.start()
        
        childCoordinators = [marketCoordinator, watchlistCoordinator]
        
        tabBarController.viewControllers = [
            marketCoordinator.navigationController,
            watchlistCoordinator.navigationController
        ]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    init(window: UIWindow, tabBarController: UITabBarController, services: Services) {
        self.window = window
        self.tabBarController = tabBarController
        self.services = services
    }
}
