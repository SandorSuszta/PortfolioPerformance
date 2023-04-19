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
           
        }
    }
}
