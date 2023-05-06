import UIKit

enum AppTab {
    case market
    case watchlist
    
    var title: String {
        switch self {
        case .market:
            return "Market"
        case .watchlist:
            return "Watchlist"
        }
    }
    
    var imageName: String {
        switch self {
        case .market:
            return "home"
        case .watchlist:
            return "star"
        }
    }
    
    var tabBarItem: UITabBarItem {
        return UITabBarItem(
            title: title,
            image: UIImage(named: imageName),
            selectedImage: nil
        )
    }
}
