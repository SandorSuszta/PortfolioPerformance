import Foundation
import Charts

final class CoinDetailsViewModel {
    
    // MARK: - Dependencies
    
    private let networkingService: NetworkingServiceProtocol
    private let watchlistStore: WatchlistStore
    
    let representedCoin: CoinRepresenatable
    
    var coinID: String {
        representedCoin.id
    }
    
    var isFavourite: Bool {
        watchlistStore.watchlist.contains(representedCoin.id)
    }

    let rangeIntervals = TimeRangeInterval.allCases
    
    //MARK: - Observables
    
    var metricsViewModelState: ObservableObject<MetricsViewModelState> = ObservableObject(value: .loading)
    var rangeDetailsViewModelState: ObservableObject<RangeDetailsViewModelState> = ObservableObject(value: .loading)
    var detailsCellViewModels: ObservableObject<[DetailsCellsViewModel]> = ObservableObject(value: [])
    var errorsState: ObservableObject<ErrorState> = ObservableObject(value: .noErrors)
    
    init(
        representedCoin: CoinRepresenatable,
        networkingService: NetworkingServiceProtocol,
        watchlistStore: WatchlistStore
    ){
        self.representedCoin = representedCoin
        self.networkingService = networkingService
        self.watchlistStore = watchlistStore
        makeDetailsCellsViewModels(metricsModel: nil)
        getMetricsData()
    }
    
    //MARK: - API
    
    func getMetricsData() {
        networkingService.getDetailsData(for: representedCoin.id ) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let model):
                self.metricsViewModelState.value = .dataReceived(MetricsViewModel(model: model))
                
            case .failure(let error):
                self.errorsState.value = .error(error)
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
                self.rangeDetailsViewModelState.value = .dataReceived(RangeDetailsViewModel(priceModels: priceData.prices))
                
            case .failure(let error):
                self.errorsState.value = .error(error)
            }
        }
    }
    
    func resetError() {
        errorsState.value = .noErrors
    }
    
    func makeDetailsCellsViewModels(metricsModel: CoinDetails?) {
        
        let viewModels: [DetailsCellsViewModel] = [
            DetailsCellsViewModel(
                type: .marketCap,
                value: .bigNumberString(from: metricsModel?.marketData.marketCap["usd"] ?? 0)
            ),
            DetailsCellsViewModel(
                type: .volume,
                value: .bigNumberString(from: metricsModel?.marketData.totalVolume["usd"] ?? 0)
            ),
            DetailsCellsViewModel(
                type: .circulatingSupply,
                value: .bigNumberString(from: Double(metricsModel?.marketData.circulatingSupply ?? 0), style: .decimal)
            ),
            DetailsCellsViewModel(
                type: .totalSupply,
                value: .bigNumberString(from: Double(metricsModel?.marketData.totalSupply ?? 0), style: .decimal)
            ),
            DetailsCellsViewModel(
                type: .maxSupply,
                value: .bigNumberString(from: Double(metricsModel?.marketData.maxSupply ?? 0), style: .decimal)
            ),
            DetailsCellsViewModel(
                type: .allTimeHigh,
                value: .priceString(from: metricsModel?.marketData.ath["usd"] ?? 0)
            ),
            DetailsCellsViewModel(
                type: .changeFromATH,
                value: .percentageString(from: metricsModel?.marketData.athChangePercentage["usd"] ?? 0)
            ),
            DetailsCellsViewModel(
                type: .ATHDate,
                value: .formatedStringForATHDate(fromUTC: metricsModel?.marketData.athDate["usd"] ?? "N/A")
            )
        ]
        
        detailsCellViewModels.value = viewModels
    }
}
