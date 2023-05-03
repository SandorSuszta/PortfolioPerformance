import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
//    var navigationController: UINavigationController { get set }
    var watchlistStore: WatchlistStoreProtocol { get set }
    var recentSearchesStore: RecentSearchesProtocol { get set }
    
    func start()
}
