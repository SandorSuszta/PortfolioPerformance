import UIKit

enum WatchlistSection {
    case main
}

final class WatchlistDataSource: UITableViewDiffableDataSource<WatchlistSection, CoinModel> {
    
    var onDeleteCell: ((_ indexPath: IndexPath) -> Void)?
    
    var onMoveCell: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)?
    
    var canMoveCells: Bool = true
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var snapshot = self.snapshot()
            
            if let item = itemIdentifier(for: indexPath) {
                snapshot.deleteItems([item])
                apply(snapshot, animatingDifferences: true)
                
                onDeleteCell?(indexPath)
                UserDefaultsService.shared.deleteFrom(.watchlist, ID: item.id)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        
        if let sourceItem = itemIdentifier(for: sourceIndexPath),
           let destinationItem = itemIdentifier(for: destinationIndexPath) {
            
            var snapshot = snapshot()
            
             sourceIndexPath > destinationIndexPath ?
                snapshot.moveItem(sourceItem, beforeItem: destinationItem)
                : snapshot.moveItem(sourceItem, afterItem: destinationItem)
            
            apply(snapshot)
            
            onMoveCell?(sourceIndexPath, destinationIndexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        canMoveCells
    }
}
