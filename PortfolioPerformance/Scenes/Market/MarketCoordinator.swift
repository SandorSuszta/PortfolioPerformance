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
}
