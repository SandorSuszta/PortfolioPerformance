import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    let window: UIWindow
    
    let tabBarController: UITabBarController
    
    var watchlistStore: WatchlistStoreProtocol
    var recentSearchesStore: RecentSearchesStoreProtocol
    
    func start() {
        
        let marketCoordinator = MarketCoordinator(
            watchlistStore: watchlistStore,
            recentSearchesStore: recentSearchesStore,
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
    
    init(window: UIWindow, tabBarController: UITabBarController, watchlistStore: WatchlistStoreProtocol, recentSearchesStore: RecentSearchesStoreProtocol) {
        self.window = window
        self.tabBarController = tabBarController
        self.watchlistStore = watchlistStore
        self.recentSearchesStore = recentSearchesStore
    }
}

//class AppCoordinator: Coordinator {
//    var childCoordinators = [Coordinator]()
//    var navigationController: UINavigationController?
//    let databaseService: DatabaseService
//    let window: UIWindow
//
//    init(window: UIWindow, databaseService: DatabaseService) {
//        self.window = window
//        self.databaseService = databaseService
//    }
//
//    func start() {
//        let tabBarController = UITabBarController()
//
//        let firstTabCoordinator = FirstTabCoordinator(navigationController: UINavigationController(), databaseService: databaseService)
//        firstTabCoordinator.start()
//        childCoordinators.append(firstTabCoordinator)
//
//        let secondTabCoordinator = SecondTabCoordinator(navigationController: UINavigationController(), databaseService: databaseService)
//        secondTabCoordinator.start()
//        childCoordinators.append(secondTabCoordinator)
//
//        tabBarController.viewControllers = [firstTabCoordinator.navigationController, secondTabCoordinator.navigationController]
//
//        window.rootViewController = tabBarController
//        window.makeKeyAndVisible()
//    }
//}

