import UIKit

class MarketCoordinator: Coordinator {
    
    let services: Services
    
    var navigationController: UINavigationController
    
    func start() {
        let marketVC = MarketViewController(coordinator: self, viewModel: MarketViewModel(networkingService: NetworkingService()))
        
        navigationController.setViewControllers([marketVC], animated: true)
        
        navigationController.tabBarItem = AppTab.market.tabBarItem
    }
    
    init(services: Services, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func showSearch() {
        let searchVC = SearchScreenViewController(coordinator: self)
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func showDetails(viewModel: CoinDetailsViewModel) {
        let detailsVC = CoinDetailsVC(coinID: <#T##String#>, coinName: <#T##String#>, coinSymbol: <#T##String#>, logoURL: <#T##String#>, isFavourite: <#T##Bool#>)
    }
}
