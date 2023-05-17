import Foundation

protocol SearchViewControllerDelegate: AnyObject {
    func showDetails(for representedCoin: CoinRepresenatable)
}
