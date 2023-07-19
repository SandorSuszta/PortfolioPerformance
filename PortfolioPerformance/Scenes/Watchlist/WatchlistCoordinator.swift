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
        let watchlistVC = WatchlistViewController(coordinator: self)
        
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
    
    func showPopUp(on parentViewController: UIViewController, coinName: String) {
        let popUp = WatchlistPopUp(superView: parentViewController.view, coinName: coinName)
        
        // Ensure layout is up to date before animation
        parentViewController.view.layoutIfNeeded()
        
        let slideIn = {
            popUp.changeBottomConstraintConstant(to: -WatchlistPopUp.Constants.padding)
            parentViewController.view.layoutIfNeeded()
        }
        
        let slideOut: (Bool) -> Void = { done in
            if done {
                UIView.animate(withDuration: 0.5, delay: 1.5) {
                    popUp.changeBottomConstraintConstant(to: WatchlistPopUp.Constants.viewHeight)
                    parentViewController.view.layoutIfNeeded()
                } completion: { done in
                    if done { popUp.removeFromSuperview() }
                }
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.5, animations: slideIn, completion: slideOut)
    }
}

    //MARK: - Search Delegate Method

extension WatchlistCoordinator: SearchViewControllerDelegate {
    
    func handleSelection(of representedCoin: CoinRepresenatable) {
        services.watchlistStore.saveToWatchlist(id: representedCoin.id)
        navigationController.popViewController(animated: true)
        
        guard let watchlistVC = navigationController.viewControllers.first else { return }
        
        showPopUp(on: watchlistVC, coinName: representedCoin.symbol.uppercased())
    }
}
