import UIKit

enum WatchlistSection {
    case main
}

final class WatchlistDataSource: UITableViewDiffableDataSource<WatchlistSection, CoinModel> {
    
    var didReorderCells: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)?
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var snapshot = self.snapshot()
            
            if let item = itemIdentifier(for: indexPath) {
                snapshot.deleteItems([item])
                UserDefaultsService.shared.deleteFrom(.watchlist, ID: item.id)
                apply(snapshot, animatingDifferences: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        didReorderCells?(sourceIndexPath, destinationIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
