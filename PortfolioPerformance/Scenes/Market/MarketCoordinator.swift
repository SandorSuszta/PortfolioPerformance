import UIKit

class MarketCoordinator: Coordinator {
  
    let services: Services
    var navigationController: UINavigationController
    
    //MARK: - Init
    
    init(navigationController: UINavigationController, services: Services) {
        self.services = services
        self.navigationController = navigationController
    }
    
    //MARK: - Methods
    
    func start() {
        let marketVC = MarketViewController(coordinator: self, viewModel: MarketViewModel(networkingService: DefaultNetworkingService()))
        
        navigationController.setViewControllers([marketVC], animated: true)
        navigationController.tabBarItem = AppTab.market.tabBarItem
    }
    
    func showSearch() {
        let searchVC = SearchScreenViewController(coordinator: self)
        searchVC.delegate = self
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func showDetails(for representedCoin: CoinRepresenatable) {
        let detailsVM = CoinDetailsViewModel(
            representedCoin: representedCoin,
            networkingService: DefaultNetworkingService(),
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
    
    func showError() {
        
    }
}

extension MarketCoordinator: SearchViewControllerDelegate {
    func handleSelection(of representedCoin: CoinRepresenatable) {
        showDetails(for: representedCoin)
    }
}
