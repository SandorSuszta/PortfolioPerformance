import Foundation

class MarketViewModel {
    
    let networkingService: NetworkingService
    
    public var cardViewModels: ObservableObject<[MarketCardCellViewModel]> = ObservableObject(value: [])
    
    public var cellViewModels: ObservableObject<[CryptoCurrencyCellViewModel]> = ObservableObject(value:[])
    
    public var errorMessage: ObservableObject<String>?
    
    public let sortOptionsArray = ["Highest Cap", "Top Winners", "Top Losers", "Top Volume"]
    
    private let viewModelQueue = DispatchQueue(label: "viewModelQueue", attributes: .concurrent)
    
    //MARK: - Init
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
        
        loadGreedAndFearIndex()
        getGlobalData()
        loadAllCryptoCurrenciesData()
    }
    
    //MARK: - Public methods
    
    public func loadGreedAndFearIndex() {
        NetworkingService.shared.requestGreedAndFearIndex { result in
            switch result {
            case .success(let index):
                
                let greedAndFearCellViewModel = MarketCardCellViewModel(
                    cellType: .greedAndFear,
                    mainMetricValue: index.data[0].value,
                    secondaryMetricValue: index.data[0].valueClassification,
                    progressValue: (Float(index.data[0].value) ?? 0) / 100
                )
                
                self.cardViewModels.value?.append(greedAndFearCellViewModel)
                
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
    
    public func getGlobalData() {
        networkingService.request(
            router: .getGlobalData,
            expectingType: GlobalDataResponse.self
        ){ result in
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
                    progressValue: Float(totalMarketCap / allTimeHighMarketCap)
                )
                
                //Create view model for BTC Dominance Card
                let dominanceCardModel = MarketCardCellViewModel(
                    cellType: .bitcoinDominance,
                    mainMetricValue: .percentageString(from: btcDominance, positivePrefix: ""),
                    secondaryMetricValue: "",
                    progressValue: Float(btcDominance / 100)
                )
                
                //Add card view models to the observable array
                self.viewModelQueue.sync {
                    self.cardViewModels.value?.append(contentsOf: [marketCapCellViewModel,dominanceCardModel])
                }
                
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
    
    func loadAllCryptoCurrenciesData() {
        NetworkingService.shared.requestCryptoCurrenciesData { result in
            
            switch result {
            case .success(let cryptosArray):
                //Transform array of coin models into array of cell view models
                self.cellViewModels.value = cryptosArray.compactMap({ .init(coinModel: $0) })
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
                
            }
        }
    }
}
