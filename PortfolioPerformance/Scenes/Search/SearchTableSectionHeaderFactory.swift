import UIKit

protocol SectionHeaderFactoryProtocol: AnyObject {
    func makeHeader(for section: SearchTableSection, tableView: UITableView) -> UIView?
}

/// Factory class responsible for creating section header views for the search table view.
class SectionHeaderFactory {
    
    func makeHeader(for section: SearchTableSection, tableView: UITableView) -> UIView? {
        switch section {
        case .searchResults:
            return nil
        case .recentSearches:
            return makeRecentSearchesHeader(tableView: tableView)
        case .trendingCoins:
            return makeTrendingCoinsHeader(tableView: tableView)
        }
    }
    
    private func makeRecentSearchesHeader(tableView: UITableView) -> UIView {
        let header = PPSectionHeaderView(
            withTitle: SearchTableSection.recentSearches.title,
            shouldDisplayButton: true,
            buttonTitle: SearchTableSection.recentSearches.buttonTitle,
            frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: PPSectionHeaderView.preferredHeight)
        )
        header.delegate = tableView.dataSource as? PPSectionHeaderViewDelegate
        return header
    }
    
    private func makeTrendingCoinsHeader(tableView: UITableView) -> UIView {
        let header = PPSectionHeaderView(
            withTitle: SearchTableSection.trendingCoins.title,
            shouldDisplayButton: false,
            frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: PPSectionHeaderView.preferredHeight)
        )
        return header
    }
}
