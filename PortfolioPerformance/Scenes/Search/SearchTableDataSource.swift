import UIKit

final class SearchTableDataSource: UITableViewDiffableDataSource<SearchTableSection, SearchResult> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultsCell.identifier) as? ResultsCell else { return UITableViewCell() }
            
            cell.imageDownloader = ImageService()
            cell.configure(withModel: model)
        
            return cell
        }
        
        defaultRowAnimation = .fade
    }
}
