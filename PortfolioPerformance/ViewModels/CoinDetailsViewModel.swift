import Foundation
import Charts

class CoinDetailsViewModel {
    
    //MARK: - Model
    
    public var coinID: String
    
    public var coinModel: SingleCoinModel?
    
    //MARK: - Observables
    public var metricsData: ObservableObject<MetricsData> = ObservableObject(value: nil)
    
    public var chartDataEntries: ObservableObject<[ChartDataEntry]> = ObservableObject(value: [])
    
    public var rangeData: ObservableObject<RangeDetails> = ObservableObject(value: nil)
    
    public var detailsTableViewCelsViewModels: ObservableObject<[DetailsTableviewCellsViewModel]> = ObservableObject(value: [])
    
    
    //MARK: - Public methods
    
    public func getMetricsData(coinID: String) {
        
        NetworkingManager.shared.requestData(for: coinID) { result in
            switch result {
            case .success(let model):
                self.coinModel = model
                let metrics = MetricsData(
                    name: model.name,
                    symbol: model.symbol,
                    imageUrl: model.image.large,
                    currentPrice: .priceString(from: model.marketData.currentPrice["usd"] ?? 0),
                    athPrice: .priceString(from: model.marketData.ath["usd"] ?? 0),
                    athChangePercentage: .percentageString(from: model.marketData.athChangePercentage["usd"] ?? 0),
                    athDate: model.marketData.athDate["usd"] ?? "N/A",
                    marketCap: .bigNumberString(from: model.marketData.marketCap["usd"] ?? 0),
                    volume: .bigNumberString(from: model.marketData.totalVolume["usd"] ?? 0, style: .decimal),
                    circulatingSupply: "",
                    totalSupply: "",
                    maxSupply: ""
                )
                self.metricsData.value = metrics
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func createDetailsCellsViewModels() {
        var viewModels: [DetailsTableviewCellsViewModel] = []
        viewModels.append(.init(
            name: "Market Cap Value",
            value: metricsData.value?.marketCap ?? ""
        ))
        viewModels.append(.init(
            name: "Volume",
            value: .bigNumberString(from: coinModel?.marketData.totalVolume["usd"] ?? 0)
        ))
        viewModels.append(.init(
            name: "Circulating supply",
            value: .bigNumberString(from: Double(coinModel?.marketData.circulatingSupply ?? 0), style: .decimal)
        ))
        viewModels.append(.init(
            name: "Total supply",
            value: .bigNumberString(from: Double(coinModel?.marketData.totalSupply ?? 0))
        ))
        viewModels.append(.init(
            name: "Max supply",
            value: .bigNumberString(from: Double(coinModel?.marketData.maxSupply ?? 0), style: .decimal)
        ))
        viewModels.append(.init(
            name: "All time high",
            value: .priceString(from: coinModel?.marketData.ath["usd"] ?? 0)
        ))
        
        detailsTableViewCelsViewModels.value = viewModels
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
        let currentPrice = self.coinModel?.marketData.currentPrice["usd"] ?? 0.0
        
        let percentFromLow = (currentPrice / rangeLow - 1) * 100
        let percentFromHigh = (currentPrice / rangeHigh - 1) * 100
        
        let rangeProgress = (currentPrice - rangeLow) / (rangeHigh - rangeLow)
        
        let rangeDetailsViewModel = RangeDetails(
            rangePriceChange: .priceString(from: rangePriceChange),
            rangePriceChangePercentage: "(" + .percentageString(from: rangePriceChangePercentage) + ")",
            rangeLow: .priceString(from: rangeLow),
            rangeHigh: .priceString(from: rangeHigh),
            percentFromHigh: .percentageString(from: percentFromHigh),
            percentFromLow: .percentageString(from: percentFromLow),
            rangeProgress: Float(rangeProgress),
            isPriceChangeNegative: isChangeNegative
        )
        return rangeDetailsViewModel
    }
    //MARK: - Init
    
    init(coinID: String) {
        self.coinID = coinID
    }
}

struct MetricsData {
    public var name: String
    public var symbol: String
    public var imageUrl: String
    public var imageData: Data? = nil
    public var currentPrice: String
    public var athPrice: String
    public var athChangePercentage: String
    public var athDate: String
    public var marketCap: String
    public var volume: String
    public var circulatingSupply: String
    public var totalSupply: String
    public var maxSupply:String
    public var isFavourite: Bool = false
}

struct RangeDetails {
    public var rangePriceChange: String
    public var rangePriceChangePercentage: String
    public var rangeLow: String
    public var rangeHigh: String
    public var percentFromHigh: String
    public var percentFromLow: String
    public var rangeProgress: Float
    public var isPriceChangeNegative: Bool
}
    
struct DetailsTableviewCellsViewModel {
    public var name: String
    public var value: String
}
