import Foundation
import UIKit

enum TabBarControllerType: CaseIterable {
    case market
    case watchlist
    
    var imageName: String {
        switch self {
        case .market:
            return "home"
        case .watchlist:
            return "star"
        }
    }
    var viewController: UIViewController {
        switch self {
        case .market:
            return UIViewController()
        case .watchlist:
            return WatchlistViewController()
        }
    }
}

final class PPTabBarController: UITabBarController {
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBars()
        makeTabBarTransparent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createTabBarBackgroundLayer()
    }
    
    //MARK: - Private methods
    
    private func setupTabBars() {
        var viewControllers: [UIViewController] = []
        
        for controllerType in TabBarControllerType.allCases {
            let navController = UINavigationController(rootViewController: controllerType.viewController)
            navController.tabBarItem.image = UIImage(named: controllerType.imageName)
            navController.tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
            
            viewControllers.append(navController)
        }
        
        setViewControllers(viewControllers, animated: false)
    }
    
    private func createTabBarBackgroundLayer() {
        let layer = CAShapeLayer()
        
        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: tabBar.bounds.minY + 10, width: tabBar.bounds.width, height: tabBar.bounds.height + 50), cornerRadius: 25).cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.3
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.secondarySystemBackground.cgColor

        tabBar.layer.insertSublayer(layer, at: 0)
    }
    
    private func makeTabBarTransparent() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        tabBar.isTranslucent = true
    }
}
