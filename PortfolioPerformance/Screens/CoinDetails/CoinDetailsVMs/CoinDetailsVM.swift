import Foundation
import Charts

final class CoinDetailsViewModel {
    
    var coinID: String
    var coinModel: SingleCoinModel?
    var marketCapRank: String {
        String(coinModel?.marketData.marketCapRank ?? 0)
    }
    let chartIntervals = ["1D", "1W", "1M", "6M", "1Y", "MAX"]
    
    //MARK: - Observable properties
    var metricsVM: ObservableObject<MetricsViewModel> = ObservableObject(value: nil)
    var rangeDetailsVM: ObservableObject<RangeDetailsViewModel> = ObservableObject(value: nil)
    var detailsTableViewCelsVM: ObservableObject<[DetailsCellsViewModel]> = ObservableObject(value: [])
    var errorMessage: ObservableObject<String> = ObservableObject(value: nil)
    
    //MARK: - Init
    init(coinID: String) {
        self.coinID = coinID
        getMetricsData(coinID: coinID)
    }
    
    //MARK: - Public methods
    func getMetricsData(coinID: String) {
        NetworkingService.shared.requestData(for: coinID) { result in
            switch result {
            case .success(let model):
                self.coinModel = model
                self.metricsVM.value = MetricsViewModel(model: model)
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    func getTimeRangeDetails(coinID: String, intervalInDays: Int) {
        NetworkingService.shared.requestDataForChart(
            coinID: coinID,
            intervalInDays: intervalInDays
        ){ result in
            switch result {
            case .success(let priceData):
                
                let rangeDetails = RangeDetailsViewModel(
                    priceModels: self.extractPriceSubset(from: priceData.prices),
                    currentPriceValue: self.coinModel?.marketData.currentPrice["usd"] ?? 0
                )
                self.rangeDetailsVM.value = rangeDetails
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    func createDetailsCellsViewModels() {
        var viewModels: [DetailsCellsViewModel] = []
        viewModels.append(.init(
            name: "Market Cap Value",
            value: metricsVM.value?.marketCap ?? ""
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
            value: .bigNumberString(from: Double(coinModel?.marketData.totalSupply ?? 0), style: .decimal)
        ))
        viewModels.append(.init(
            name: "Max supply",
            value: .bigNumberString(from: Double(coinModel?.marketData.maxSupply ?? 0), style: .decimal)
        ))
        viewModels.append(.init(
            name: "All time high",
            value: .priceString(from: coinModel?.marketData.ath["usd"] ?? 0)
        ))
        viewModels.append(.init(
            name: "Change percentage from ATH",
            value: .percentageString(from: coinModel?.marketData.athChangePercentage["usd"] ?? 0)
        ))
        viewModels.append(.init(
            name: "ATH date",
            value: .formatedStringForATHDate(fromUTC: coinModel?.marketData.athDate["usd"] ?? "N/A")
        ))
        detailsTableViewCelsVM.value = viewModels
    }
    
    /// Extracts a subset  from an array of prices. Makes chart look cleaner and less cluttered.
    /// - Parameters:
    ///   - prices: The input array of prices.
    ///   - subsetSize: The number of elements to include in the subset. Defaults to 60.
    /// - Returns:  A new array containing `subsetSize` elements, where each element is taken from the original array at equal intervals.
    private func extractPriceSubset(from prices: [[Double]], subsetSize: Int = 60) -> [[Double]] {
        guard !prices.isEmpty else { return [] }
        guard prices.count > subsetSize else { return prices }
        
        let step = prices.count / subsetSize
        
        return prices.enumerated().reduce(into: []) { subset, enumeratedElement in
            if enumeratedElement.offset % step == 0 {
                subset.append(enumeratedElement.element)
            }
        }
    }
}
