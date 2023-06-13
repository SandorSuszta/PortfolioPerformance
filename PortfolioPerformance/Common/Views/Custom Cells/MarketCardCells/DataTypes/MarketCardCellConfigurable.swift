import Foundation

protocol MarketCardCellConfigurable: AnyObject {
    func configure(with viewModel: MarketCardCellViewModel)
}
