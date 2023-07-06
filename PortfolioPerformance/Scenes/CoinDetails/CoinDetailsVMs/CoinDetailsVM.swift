import Foundation
import Charts

final class CoinDetailsViewModel {
    
    // MARK: - Dependencies
    
    private let networkingService: NetworkingServiceProtocol
    private let watchlistStore: WatchlistStoreProtocol
    private var coinDetailsModel: CoinDetails?
    
    let representedCoin: CoinRepresenatable
    
    var coinID: String {
        representedCoin.id
    }
    
    var isFavourite: Bool {
        watchlistStore.getWatchlist().contains(representedCoin.id)
    }
    
    var marketCapRank: String {
        String(coinDetailsModel?.marketData.marketCapRank ?? 0)
    }

    let rangeIntervals = TimeRangeInterval.allCases
    
    //MARK: - Observables
    
    var metricsVM: ObservableObject<MetricsViewModel> = ObservableObject(value: nil)
    var rangeDetailsVM: ObservableObject<RangeDetailsViewModel> = ObservableObject(value: nil)
    var detailsTableViewCelsVM: ObservableObject<[DetailsCellsViewModel]> = ObservableObject(value: [])
    var errorMessage: ObservableObject<String> = ObservableObject(value: nil)
    
    //MARK: - Init
    
    init(
        representedCoin: CoinRepresenatable,
        networkingService: NetworkingServiceProtocol,
        watchlistStore: WatchlistStoreProtocol
    ){
        self.representedCoin = representedCoin
        self.networkingService = networkingService
        self.watchlistStore = watchlistStore
        
        getMetricsData(for: representedCoin.id)
    }
    
    //MARK: - Public methods
    func getMetricsData(for ID: String) {
        networkingService.getDetailsData(for: representedCoin.id ) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let model):
                self.coinDetailsModel = model
                self.metricsVM.value = MetricsViewModel(model: model)
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    func getTimeRangeDetails(coinID: String, intervalInDays: Int) {
        networkingService.getChartData(
            for: coinID,
            inDaysInterval: intervalInDays
        ){ [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let priceData):
                
                let rangeDetails = RangeDetailsViewModel(
                    priceModels: self.extractPriceSubset(from: priceData.prices),
                    currentPriceValue: self.coinDetailsModel?.marketData.currentPrice["usd"] ?? 0
                )
                self.rangeDetailsVM.value = rangeDetails
                
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    func createDetailsCellsViewModels() {
        let viewModels: [DetailsCellsViewModel] = [
            DetailsCellsViewModel(
                name: "Market Cap Value",
                value: metricsVM.value?.marketCap ?? ""
            ),
            DetailsCellsViewModel(
                name: "Volume",
                value: .bigNumberString(from: coinDetailsModel?.marketData.totalVolume["usd"] ?? 0)
            ),
            DetailsCellsViewModel(
                name: "Circulating supply",
                value: .bigNumberString(from: Double(coinDetailsModel?.marketData.circulatingSupply ?? 0), style: .decimal)
            ),
            DetailsCellsViewModel(
                name: "Total supply",
                value: .bigNumberString(from: Double(coinDetailsModel?.marketData.totalSupply ?? 0), style: .decimal)
            ),
            DetailsCellsViewModel(
                name: "Max supply",
                value: .bigNumberString(from: Double(coinDetailsModel?.marketData.maxSupply ?? 0), style: .decimal)
            ),
            DetailsCellsViewModel(
                name: "All time high",
                value: .priceString(from: coinDetailsModel?.marketData.ath["usd"] ?? 0)
            ),
            DetailsCellsViewModel(
                name: "Change percentage from ATH",
                value: .percentageString(from: coinDetailsModel?.marketData.athChangePercentage["usd"] ?? 0)
            ),
            DetailsCellsViewModel(
                name: "ATH date",
                value: .formatedStringForATHDate(fromUTC: coinDetailsModel?.marketData.athDate["usd"] ?? "N/A")
            )
        ]
        
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
