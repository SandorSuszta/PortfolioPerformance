import Foundation

struct DefaultMarketCardContentViewModelFactory: MarketCardContentViewModelFactory {
    
    // MARK: - Loading
    
    func makeLoadingContentViewModel() -> MarketCardContentViewModel {
        return .loading(id: UUID())
    }
    
    // MARK: - Market Cap
    
    func makeMarketCapViewModel(from globalDataResponse: GlobalDataResponse) -> MarketCardContentViewModel {
        let totalMarketCap = globalDataResponse.data.totalMarketCap["usd"] ?? 0
        let marketCapChangeFor24H = globalDataResponse.data.marketCapChangePercentage24HUsd
        let allTimeHighMarketCap: Double = 3_030_000_000_000
        
        let marketCardItemViewModel = MarketCardItemViewModel(
            cellType: .totalMarketCap,
            mainMetricValue: .bigNumberString(from: totalMarketCap),
            secondaryMetricValue: .percentageString(from: marketCapChangeFor24H),
            progressValue: Float(totalMarketCap / allTimeHighMarketCap),
            isChangePositive: marketCapChangeFor24H > 0
        )
        
        return .item(marketCardItemViewModel)
    }
    
    // MARK: - Bitcoin Dominance
    
    func makeBitcoinDominanceViewModel(from globalDataResponse: GlobalDataResponse) -> MarketCardContentViewModel {
        let btcDominance = globalDataResponse.data.marketCapPercentage["btc"] ?? 0
        
        let btcDominanceItemViewModel = MarketCardItemViewModel(
            cellType: .bitcoinDominance,
            mainMetricValue: .percentageString(from: btcDominance, positivePrefix: ""),
            secondaryMetricValue: "",
            progressValue: Float(btcDominance / 100),
            isChangePositive: true
        )
        
        return .item(btcDominanceItemViewModel)
    }
    
    // MARK: - Greed and Fear
    
    func makeGreedAndFearViewModel(from greedAndFearResponse: GreedAndFearResponse) -> MarketCardContentViewModel {
        
        let greedAndFearItemViewModel = MarketCardItemViewModel(
            cellType: .greedAndFear,
            mainMetricValue: greedAndFearResponse.data[0].value,
            secondaryMetricValue:  greedAndFearResponse.data[0].valueClassification,
            progressValue: (Float(greedAndFearResponse.data[0].value) ?? 0) / 100,
            isChangePositive: nil
        )
        
        return .item(greedAndFearItemViewModel)
    }
}
