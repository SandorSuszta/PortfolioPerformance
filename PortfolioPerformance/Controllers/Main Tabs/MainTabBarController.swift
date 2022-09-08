//
//  MainTabBarController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 13/07/2022.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        let market = MarketViewController()
        let watchlist = WatchlistViewController()
        
        let navController1 = UINavigationController(rootViewController: market)
        let navController2 = UINavigationController(rootViewController: watchlist)
        let navController3 = UINavigationController(rootViewController: MarketViewController())
        let navController4 = UINavigationController(rootViewController: MarketViewController())
        let navController5 = UINavigationController(rootViewController: MarketViewController())
                
        setViewControllers([
            navController1,
            navController2,
            navController3,
            navController4,
            navController5
        ], animated: false)
        
        tabBar.items?[0].image = UIImage(named: "market")
        tabBar.items?[0].title = "Market"
    
        tabBar.items?[1].image = UIImage(named: "star")
        tabBar.items?[1].title = "Watchlist"
        
        tabBar.items?[2].image = UIImage(named: "add")
        tabBar.items?[2].title = "Add"
        
        tabBar.items?[3].image = UIImage(named: "transaction")
        tabBar.items?[3].title = "History"
        
        tabBar.items?[4].image = UIImage(named: "portfolio")
        tabBar.items?[4].title = "Portfolio"
    }
}
