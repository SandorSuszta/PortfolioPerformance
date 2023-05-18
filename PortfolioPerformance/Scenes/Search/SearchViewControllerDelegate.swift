import Foundation

protocol SearchViewControllerDelegate: AnyObject {
    func handleSelection(of representedCoin: CoinRepresenatable)
}
