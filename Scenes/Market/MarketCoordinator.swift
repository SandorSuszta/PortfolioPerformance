import UIKit

class MarketCoordinator: Coordinator {
    var watchlistStore: WatchlistStoreProtocol
    
    var recentSearchesStore: RecentSearchesProtocol
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    func start() {
        let marketVC = MarketViewController(coordinator: self, viewModel: MarketViewModel())
        navigationController.setViewControllers([marketVC], animated: true)
        
        navigationController.tabBarItem = UITabBarItem(title: "Market", image: .init(systemName: "star"), selectedImage: nil)
    }
    
    init(watchlistStore: WatchlistStoreProtocol, recentSearchesStore: RecentSearchesProtocol, navigationController: UINavigationController) {
        self.watchlistStore = watchlistStore
        self.recentSearchesStore = recentSearchesStore
        self.navigationController = navigationController
    }
}
