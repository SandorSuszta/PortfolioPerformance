import Foundation

protocol SearchViewControllerDelegate: AnyObject {
    func didSelectCell(withSearchResult: SearchResult)
}
