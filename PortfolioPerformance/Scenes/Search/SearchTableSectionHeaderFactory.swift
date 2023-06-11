import UIKit

protocol SectionHeaderFactoryProtocol {
    func makeHeader(for section: SearchTableSection, tableView: UITableView) -> SearchTableSectionHeader?
}

/// Factory class responsible for creating section header views for the search table view.
final class SectionHeaderFactory: SectionHeaderFactoryProtocol {
    
    func makeHeader(for section: SearchTableSection, tableView: UITableView) -> SearchTableSectionHeader? {
        switch section {
        case .searchResults:
            return nil
        case .recentSearches:
            return makeRecentSearchesHeader(tableView: tableView)
        case .trendingCoins:
            return makeTrendingCoinsHeader(tableView: tableView)
        }
    }
    
    private func makeRecentSearchesHeader(tableView: UITableView) -> SearchTableSectionHeader {
        let header = SearchTableSectionHeader(
            withTitle: SearchTableSection.recentSearches.title,
            shouldDisplayButton: true,
            buttonTitle: SearchTableSection.recentSearches.buttonTitle,
            frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SearchTableSectionHeader.preferredHeight)
        )
        return header
    }
    
    private func makeTrendingCoinsHeader(tableView: UITableView) -> SearchTableSectionHeader {
        let header = SearchTableSectionHeader(
            withTitle: SearchTableSection.trendingCoins.title,
            shouldDisplayButton: false,
            frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SearchTableSectionHeader.preferredHeight)
        )
        return header
    }
}
