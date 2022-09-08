import Foundation
import Charts

class CoinDetailsViewModel {
    
    //MARK: - Properties
    
    public let coinModel: CoinModel
    
    public var name: String {
        coinModel.name
    }
    public var symbol: String {
        coinModel.symbol.uppercased()
    }
    public var imageUrl: String {
        coinModel.image
    }
    public var imageData: Data? = nil
    
    public var currentPrice: String {
        .priceString(from: coinModel.currentPrice)
    }
    public var priceChange24H: String {
        .priceString(from: coinModel.priceChange24H ?? 0)
    }
    public var priceChangePercentage24H: String {
        .percentageString(from: coinModel.priceChangePercentage24H ?? 0)
    }
    public var athPrice: String {
        .priceString(from: coinModel.ath ?? 0)
    }
    public var athChangePercentage: String {
        .percentageString(from: coinModel.athChangePercentage ?? 0)
    }
    public var athDate: String {
        //Convert ISO8601 Date from API
        .formatedDateString(from: coinModel.athDate ?? "")
    }
    
    public var isFavourite: Bool = false
    
    public var isPriceChangeNegative: Bool {
        coinModel.priceChange24H ?? 0 > 0 ? false : true
    }
    
    //MARK: - Observables
    
    public var chartDataEntries: ObservableObject<[ChartDataEntry]> = ObservableObject(value: [])
    
    public var rangeData: ObservableObject<RangeDetails> = ObservableObject(value: nil)
    
    public var metricsTableViewCelsViewModels = [MetricsTableviewCellsViewModel]()
    
    //MARK: - Public methods
    
    public func getChartDataEntries(coinID: String, intervalInDays: Int) {
        NetworkingManager.shared.requestDataForChart(
            coinID: coinID,
            intervalInDays: intervalInDays
        ){
            result in
            switch result {
            case .success(let graphData):
                
                let entries = self.convertPricesToChartEntries(
                    prices: graphData.prices
                )
                self.chartDataEntries.value = entries
                
                let data = self.calculateRangeData(
                    prices: graphData.prices
                )
                self.rangeData.value = data
                
                print("")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - Private methods
    
    private func convertPricesToChartEntries(prices: [[Double]]) -> [ChartDataEntry] {
        
        var graphEntries: [ChartDataEntry] = []
        
        for price in prices {
                let entry = ChartDataEntry(x: price[0], y: price[1])
                graphEntries.append(entry)
        }
        return graphEntries
    }
    
    private func calculateRangeData(prices: [[Double]]) -> RangeDetails {
        let firstPrice = prices.first?[1] ?? 0.0
        let lastPrice = prices.last?[1] ?? 0.0

        let rangePriceChange = lastPrice - firstPrice
        let isChangeNegative = rangePriceChange < 0
        let rangePriceChangePercentage = (lastPrice / firstPrice - 1) * 100
        
        let sortedPrices = prices.sorted { $0[1] < $1[1] }
        let rangeLow = sortedPrices.first?[1] ?? 0.0
        let rangeHigh = sortedPrices.last?[1] ?? 0.0
        
        let percentFromLow = (self.coinModel.currentPrice / rangeLow - 1) * 100
        let percentFromHigh = (self.coinModel.currentPrice / rangeHigh - 1) * 100
        
        let rangeProgress = (self.coinModel.currentPrice - rangeLow) / (rangeHigh - rangeLow)
        
        let rangeDetails = RangeDetails(
            rangePriceChange: .priceString(from: rangePriceChange),
            rangePriceChangePercentage: .percentageString(from: rangePriceChangePercentage),
            rangeLow: .priceString(from: rangeLow),
            rangeHigh: .priceString(from: rangeHigh),
            percentFromHigh: .percentageString(from: percentFromHigh),
            percentFromLow: .percentageString(from: percentFromLow),
            rangeProgress: Float(rangeProgress),
            isChangeNegative: isChangeNegative
        )
        return rangeDetails
    }
    
    private func createMetricsCellsViewModels() -> [MetricsTableviewCellsViewModel] {
        var viewModels: [MetricsTableviewCellsViewModel] = []
        viewModels.append(.init(name: "", value: "4"))
        return viewModels
    }
    
    //MARK: - Init
    
    init(coinModel: CoinModel) {
        self.coinModel = coinModel
    }
}

    struct RangeDetails {
        public var rangePriceChange: String
        public var rangePriceChangePercentage: String
        public var rangeLow: String
        public var rangeHigh: String
        public var percentFromHigh: String
        public var percentFromLow: String
        public var rangeProgress: Float = 0.5
        public var isChangeNegative: Bool
    }
    
    struct MetricsTableviewCellsViewModel {
        public var name: String
        public var value: String
    }
