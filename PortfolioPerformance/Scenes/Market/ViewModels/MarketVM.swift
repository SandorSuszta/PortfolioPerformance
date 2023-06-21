import Foundation

class MarketViewModel {
    
    let networkingService: NetworkingServiceProtocol
    
    public var cardViewModels: ObservableObject<[MarketCardCellViewModel]> = ObservableObject(value: [])
    
    public var cellViewModels: ObservableObject<[CryptoCurrencyCellViewModel]> = ObservableObject(value:[])
    
    public var errorMessage: ObservableObject<String>?
    
    public let sortOptionsArray = ["Highest Cap", "Top Winners", "Top Losers", "Top Volume"]
    
    //MARK: - Init
    
    init(networkingService: NetworkingServiceProtocol) {
        self.networkingService = networkingService
        
        loadGreedAndFearIndex()
        getGlobalData()
        loadAllCryptoCurrenciesData()
    }
    
    convenience init() {
        self.init(networkingService: NetworkingService())
    }
    
    //MARK: - Public methods
    
    public func loadGreedAndFearIndex() {
        
        networkingService.getGreedAndFearData { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let index):
                
                let greedAndFearCellViewModel = MarketCardCellViewModel(
                    cellType: .greedAndFear,
                    mainMetricValue: index.data[0].value,
                    secondaryMetricValue:  index.data[0].valueClassification,
                    progressValue: (Float(index.data[0].value) ?? 0) / 100,
                    isChangePositive: nil
                )
                
                self.cardViewModels.value?.append(greedAndFearCellViewModel)
                
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
    
    func getGlobalData() {
        networkingService.getGlobalData() { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let globalDataResponse):
                let totalMarketCap = globalDataResponse.data.totalMarketCap["usd"] ?? 0
                let marketCapChangeFor24H = globalDataResponse.data.marketCapChangePercentage24HUsd
                let allTimeHighMarketCap: Double = 3030000000000
                let btcDominance = globalDataResponse.data.marketCapPercentage["btc"] ?? 0
                
                //Create view model for Total Market Cap Card
                let marketCapCellViewModel = MarketCardCellViewModel(
                    cellType: .totalMarketCap,
                    mainMetricValue: .bigNumberString(from: totalMarketCap),
                    secondaryMetricValue: .percentageString(from: marketCapChangeFor24H),
                    progressValue: Float(totalMarketCap / allTimeHighMarketCap),
                    isChangePositive: marketCapChangeFor24H > 0
                )
                
                //Create view model for BTC Dominance Card
                let dominanceViewModel = MarketCardCellViewModel(
                    cellType: .bitcoinDominance,
                    mainMetricValue: .percentageString(from: btcDominance, positivePrefix: ""),
                    secondaryMetricValue: "",
                    progressValue: Float(btcDominance / 100),
                    //TODO: Change after 24h change implemented
                    isChangePositive: true
                )
                
                //Add card view models to the observable array
                self.cardViewModels.value?.append(contentsOf: [marketCapCellViewModel,dominanceViewModel])
                
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
    
    func loadAllCryptoCurrenciesData(sortOption: CryptoCurrenciesSortOption = .topCaps) {
        networkingService.getCryptoCurrenciesData { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let cryptosArray):
                var sortedArray: [CoinModel]
                
                switch sortOption {
                case .topCaps:
                    sortedArray = cryptosArray
                case .topWinners:
                    sortedArray = cryptosArray.sorted { $0.priceChangePercentage24H ?? 0 > $1.priceChangePercentage24H ?? 0 }
                case .topLosers:
                    sortedArray = cryptosArray.sorted { $0.priceChangePercentage24H ?? 0 < $1.priceChangePercentage24H ?? 0 }
                case .topVolumes:
                    sortedArray = cryptosArray.sorted { $0.totalVolume ?? 0 > $1.totalVolume ?? 0 }
                }
                
                //Transform array of coin models into array of cell view models
                self.cellViewModels.value = sortedArray.compactMap({ CryptoCurrencyCellViewModel(coinModel: $0)})
                
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
    
    func sortCellViewModels (by sortOption: CryptoCurrenciesSortOption) {
        guard var viewModels = cellViewModels.value else { return }
        
        switch sortOption {
        case .topCaps:
            viewModels.sort(by: {
                $0.coinModel.marketCap ?? 0 > $1.coinModel.marketCap ?? 0
            })
        case .topWinners:
            viewModels.sort(by: {
                $0.coinModel.priceChangePercentage24H ?? 0 > $1.coinModel.priceChangePercentage24H ?? 0
            })
        case .topLosers:
            viewModels.sort(by: {
                $0.coinModel.priceChangePercentage24H ?? 0  < $1.coinModel.priceChangePercentage24H ?? 0
            })
        case .topVolumes:
            viewModels.sort(by: {
                $0.coinModel.totalVolume ?? 0 > $1.coinModel.totalVolume ?? 0
            })
        }
        
        cellViewModels.value = viewModels
    }
}


