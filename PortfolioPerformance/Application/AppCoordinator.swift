import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    let window: UIWindow
    
    let tabBarController: UITabBarController
    
    let services: Services
    
    func start() {
        
        let marketCoordinator = MarketCoordinator(
            services: services,
            navigationController: UINavigationController()
        )
        
        marketCoordinator.start()
        childCoordinators.append(marketCoordinator)
        
        tabBarController.viewControllers = [
            marketCoordinator.navigationController,
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
