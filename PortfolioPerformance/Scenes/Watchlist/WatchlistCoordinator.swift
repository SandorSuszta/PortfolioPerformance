import UIKit

class WatchlistCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    let services: Services
    
    func start() {
        let watchlistVC = WatchlistViewController(coordinator: self, watchlistStore: services.watchlistStore)
        
        navigationController.setViewControllers([watchlistVC], animated: true)
        
        navigationController.tabBarItem = AppTab.watchlist.tabBarItem
    }
    
    init(navigationController: UINavigationController, services: Services) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func showDetails(for model: CoinModel) {
        
        let detailsVC = CoinDetailsVC(
            coinID: model.id,
            coinName: model.name,
            coinSymbol: model.symbol,
            logoURL: model.image,
            isFavourite: services.watchlistStore.getWatchlist().contains(model.id)
        )
        
        navigationController.pushViewController(detailsVC, animated: true)
    }
}
