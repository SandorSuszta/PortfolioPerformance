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
        watchlistStore.watchlist.contains(representedCoin.id)
    }
    
    var marketCapRank: String {
        String(coinDetailsModel?.marketData.marketCapRank ?? 0)
    }

    let rangeIntervals = TimeRangeInterval.allCases
    
    //MARK: - Observables
    
    var metricsVM: ObservableObject<MetricsViewModel> = ObservableObject(value: .loading)
    var rangeDetailsVM: ObservableObject<RangeDetailsViewModel> = ObservableObject(value: .loading)
    var detailsTableViewCelsVM: ObservableObject<[DetailsCellsViewModel]> = ObservableObject(value: .loading)
    var errorMessage: ObservableObject<String> = ObservableObject(value: .noData)
    
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
                self.metricsVM.value = .data(MetricsViewModel(model: model))
                
                
            case .failure(let error):
                self.errorMessage.value = .data(error.rawValue)
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
                self.rangeDetailsVM.value = .data(rangeDetails)
                
            case .failure(let error):
                self.errorMessage.value = .data(error.rawValue)
            }
        }
    }
    
    func makeDetailsCellsViewModels(metricViewModel: MetricsViewModel) {
        
        if case =
        
        let viewModels: [DetailsCellsViewModel] = [
            DetailsCellsViewModel(
                type: .marketCap,
                value: metricsVM.value.marketCap
            ),
            DetailsCellsViewModel(
                type: .volume,
                value: .bigNumberString(from: coinDetailsModel?.marketData.totalVolume["usd"] ?? 0)
            ),
            DetailsCellsViewModel(
                type: .circulatingSupply,
                value: .bigNumberString(from: Double(coinDetailsModel?.marketData.circulatingSupply ?? 0), style: .decimal)
            ),
            DetailsCellsViewModel(
                type: .totalSupply,
                value: .bigNumberString(from: Double(coinDetailsModel?.marketData.totalSupply ?? 0), style: .decimal)
            ),
            DetailsCellsViewModel(
                type: .maxSupply,
                value: .bigNumberString(from: Double(coinDetailsModel?.marketData.maxSupply ?? 0), style: .decimal)
            ),
            DetailsCellsViewModel(
                type: .allTimeHigh,
                value: .priceString(from: coinDetailsModel?.marketData.ath["usd"] ?? 0)
            ),
            DetailsCellsViewModel(
                type: .changeFromATH,
                value: .percentageString(from: coinDetailsModel?.marketData.athChangePercentage["usd"] ?? 0)
            ),
            DetailsCellsViewModel(
                type: .ATHDate,
                value: .formatedStringForATHDate(fromUTC: coinDetailsModel?.marketData.athDate["usd"] ?? "N/A")
            )
        ]
        
        detailsTableViewCelsVM.value = .data(viewModels)
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
