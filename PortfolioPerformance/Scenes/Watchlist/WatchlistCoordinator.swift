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
    
    func showDetails(for representedCoin: CoinRepresenatable) {
        let detailsVM = CoinDetailsViewModel(
            representedCoin: representedCoin,
            networkingService: NetworkingService(),
            watchlistStore: services.watchlistStore
        )
        
        let detailsVC = CoinDetailsVC(
            coordinator: self,
            viewModel: detailsVM,
            imageDownloader: ImageDownloader(),
            watchlistStore: services.watchlistStore
        )
        
        navigationController.pushViewController(detailsVC, animated: true)
    }
}
