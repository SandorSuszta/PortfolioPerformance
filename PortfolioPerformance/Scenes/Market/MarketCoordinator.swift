import UIKit

class MarketCoordinator: Coordinator {
    
    let services: Services
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    func start() {
        let marketVC = MarketViewController(coordinator: self, viewModel: MarketViewModel())
        navigationController.setViewControllers([marketVC], animated: true)
        
        navigationController.tabBarItem = UITabBarItem(title: "Market", image: .init(systemName: "star"), selectedImage: nil)
    }
    
    init(services: Services, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
}
