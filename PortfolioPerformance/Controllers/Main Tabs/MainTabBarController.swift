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
        
        let market = _New_MarketViewController()
        let watchlist = WatchlistViewController2()
        
        
        let navController1 = UINavigationController(rootViewController: market)
        let navController2 = UINavigationController(rootViewController: watchlist)
        let navController3 = UINavigationController(rootViewController: _New_MarketViewController())
        let navController4 = UINavigationController(rootViewController: _New_MarketViewController())
        let navController5 = UINavigationController(rootViewController: _New_MarketViewController())
        
        
        setViewControllers([
            navController1,
            navController2,
            navController3,
            navController4,
            navController5
        ], animated: false)
    }
}
