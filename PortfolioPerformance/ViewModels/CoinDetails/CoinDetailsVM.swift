import Foundation
import Charts

class CoinDetailsViewModel {
    
    public var coinID: String
    private var coinModel: SingleCoinModel?
    
    //MARK: - Observable properties
    public var metricsVM: ObservableObject<MetricsViewModel> = ObservableObject(value: nil)
    public var rangeDetailsVM: ObservableObject<RangeDetailsViewModel> = ObservableObject(value: nil)
    public var detailsTableViewCelsVM: ObservableObject<[DetailsTableviewCellsViewModel]> = ObservableObject(value: [])
    
    //MARK: - Init
    init(coinID: String) {
        self.coinID = coinID
    }
    
    //MARK: - Public methods
    public func getMetricsData(coinID: String) {
        NetworkingManager.shared.requestData(for: coinID) { result in
            switch result {
            case .success(let model):
                self.coinModel = model
                self.metricsVM.value = MetricsViewModel(model: model)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func getTimeRangeDetails(coinID: String, intervalInDays: Int) {
        NetworkingManager.shared.requestDataForChart(
            coinID: coinID,
            intervalInDays: intervalInDays
        ){
            result in
            switch result {
            case .success(let priceData):
                let rangeDetails = RangeDetailsViewModel(
                    priceModels: priceData.prices,
                    currentPriceValue: self.coinModel?.marketData.currentPrice["usd"] ?? 0
                )
                self.rangeDetailsVM.value = rangeDetails
            case .failure(let error):
                print(error)
            }
        }
    }

    public func createDetailsCellsViewModels() {
        var viewModels: [DetailsTableviewCellsViewModel] = []
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
        detailsTableViewCelsVM.value = viewModels
    }
}
