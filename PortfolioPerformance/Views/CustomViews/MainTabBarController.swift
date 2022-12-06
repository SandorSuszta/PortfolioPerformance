import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .PPblue

        let market = MarketViewController()
        let watchlist = WatchlistViewController()
        let addTransaction = AddTransactionVC()
        
        let navController1 = UINavigationController(rootViewController: market)
        let navController2 = UINavigationController(rootViewController: watchlist)
        let navController3 = UINavigationController(rootViewController: addTransaction)
//        let navController4 = UINavigationController(rootViewController: MarketViewController())
//        let navController5 = UINavigationController(rootViewController: MarketViewController())
                
        setViewControllers([
            navController1,
            navController2,
            navController3,
//            navController4,
//            navController5
        ], animated: false)
        
        tabBar.items?[0].image = UIImage(systemName: "house.fill")
        tabBar.items?[0].title = "Market"
    
        tabBar.items?[1].image = UIImage(systemName: "star.fill")
        tabBar.items?[1].title = "Watchlist"
        
        tabBar.items?[2].image = UIImage(systemName: "plus.square.on.square")
        tabBar.items?[2].title = "New"
//
//        tabBar.items?[3].image = UIImage(named: "transaction")
//        tabBar.items?[3].title = "History"
//
//        tabBar.items?[4].image = UIImage(named: "portfolio")
//        tabBar.items?[4].title = "Portfolio"
    }
}
