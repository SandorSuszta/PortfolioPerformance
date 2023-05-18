import UIKit

class WatchlistCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    let services: Services
    
    //MARK: - Init
    
    init(navigationController: UINavigationController, services: Services) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func start() {
        let watchlistVC = WatchlistViewController(coordinator: self, watchlistStore: services.watchlistStore)
        
        navigationController.setViewControllers([watchlistVC], animated: true)
        
        navigationController.tabBarItem = AppTab.watchlist.tabBarItem
    }
    
    //MARK: - Methods
    
    func showSearch() {
        let searchVC = SearchScreenViewController(coordinator: self)
        searchVC.delegate = self
        
        navigationController.pushViewController(searchVC, animated: true)
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

    //MARK: - Search Delegate Method

extension WatchlistCoordinator: SearchViewControllerDelegate {
    func handleSelection(of representedCoin: CoinRepresenatable) {
        services.watchlistStore.saveToWatchlist(id: representedCoin.id)
        navigationController.popViewController(animated: true)
    }
}
