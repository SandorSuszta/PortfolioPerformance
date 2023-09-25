import Foundation

protocol MarketCardContentViewModelFactory {
    func makeMarketCapViewModel(from globalDataResponse: GlobalDataResponse) -> MarketCardContentViewModel
    func makeBitcoinDominanceViewModel(from globalDataResponse: GlobalDataResponse) -> MarketCardContentViewModel
    func makeGreedAndFearViewModel(from greedAndFearResponse: GreedAndFearResponse) -> MarketCardContentViewModel
    func makeLoadingContentViewModel() -> MarketCardContentViewModel
}
