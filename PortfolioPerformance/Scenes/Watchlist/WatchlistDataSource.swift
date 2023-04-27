import UIKit

enum WatchlistSection {
    case main
}

final class WatchlistDataSource: UITableViewDiffableDataSource<WatchlistSection, CoinModel> {
    
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
        var sourceData = UserDefaultsService.shared.watchlistIDs
        sourceData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        UserDefaultsService.shared.replaceWatchlist(with: sourceData)
        print(UserDefaultsService.shared.watchlistIDs)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
