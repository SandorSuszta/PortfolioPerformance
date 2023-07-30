import Foundation

final class MarketViewModel {
    
    private var selectedSortOption: MarketSortOption = .topCaps {
        didSet {
            sortCellViewModels(by: selectedSortOption)
        }
    }
    
    // MARK: - Dependencies
    
    private let networkingService: NetworkingServiceProtocol
    
    // MARK: - Observables
    
    var marketCards: ObservableObject<[MarketCard]> = ObservableObject(
        value: [.loading(id: UUID()), .loading(id: UUID()), .loading(id: UUID())]
    )
    var cryptoCoinsViewModelsState: ObservableObject<CryptoCurrencyCellViewModelState> = ObservableObject(value: .loading)
    
    var errorsState: ObservableObject<ErrorState> = ObservableObject(value: .noErrors)
    
    //MARK: - Init
    
    init(networkingService: NetworkingServiceProtocol) {
        self.networkingService = networkingService
        loadMarketData()
    }
    
    convenience init() {
        self.init(networkingService: DefaultNetworkingService())
    }
    
    //MARK: - API
    
    func loadMarketData() {
        loadGreedAndFearIndex()
        getGlobalData()
        loadAllCryptoCurrenciesData(sortedBy: selectedSortOption)
    }
    
    func setSelectedSortOption(_ option: MarketSortOption) {
        selectedSortOption = option
    }
    
    func resetError() {
        errorsState.value = .noErrors
    }
    
    // MARK: - Private
    
    private func loadGreedAndFearIndex() {
        
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
                
                
                self.updateViewModels(withCards: [.dataReceived(greedAndFearCellViewModel)])
                
            case .failure(let error):
                self.errorsState.value = .error(error)
            }
        }
    }
    
    private func getGlobalData() {
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
                
                self.updateViewModels(withCards: [
                    .dataReceived(marketCapCellViewModel),
                    .dataReceived(dominanceViewModel)
                ])
                
            case .failure(let error):
                self.errorsState.value = .error(error)
            }
        }
    }
    
    private func loadAllCryptoCurrenciesData(sortedBy sortOption: MarketSortOption = .topCaps) {
        networkingService.getCryptoCurrenciesData { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let cryptosArray):
                var sortedArray: [CoinModel]
                
                switch sortOption  {
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
                let viewModels = sortedArray.compactMap { CryptoCurrencyCellViewModel(coinModel: $0) }
                
                self.cryptoCoinsViewModelsState.value = .dataReceived(viewModels)
               
                
            case .failure(let error):
                self.errorsState.value = .error(error)
            }
        }
    }
    
    ///The function updates market cards with new data, ensuring that the number of cards displayed is equal to the targetCardsCount (which is 3 in this implementation) by adding loading cards if needed.
    
    private func updateViewModels(withCards dataCards: [MarketCard]) {
        var cardsWithData = marketCards.value.filter { card in
                if case .loading = card {
                    return false
                }
                return true
            }

        cardsWithData.append(contentsOf: dataCards)
        
        let targetCardsCount = 3
        let loadingCardsCountToAdd = max(0, targetCardsCount - cardsWithData.count)
        
        let loadingCardsToAdd = Array(repeating: MarketCard.loading(id: UUID()), count: loadingCardsCountToAdd)
        
        
        marketCards.value = cardsWithData + loadingCardsToAdd
    }
    
    private func sortCellViewModels (by sortOption: MarketSortOption) {
        if case let .dataReceived(viewModels)  = cryptoCoinsViewModelsState.value {
            var sortedViewModels = viewModels
            
            switch sortOption {
            case .topCaps:
                sortedViewModels.sort(by: {
                    $0.coinModel.marketCap ?? 0 > $1.coinModel.marketCap ?? 0
                })
            case .topWinners:
                sortedViewModels.sort(by: {
                    $0.coinModel.priceChangePercentage24H ?? 0 > $1.coinModel.priceChangePercentage24H ?? 0
                })
            case .topLosers:
                sortedViewModels.sort(by: {
                    $0.coinModel.priceChangePercentage24H ?? 0  < $1.coinModel.priceChangePercentage24H ?? 0
                })
            case .topVolumes:
                sortedViewModels.sort(by: {
                    $0.coinModel.totalVolume ?? 0 > $1.coinModel.totalVolume ?? 0
                })
            }
            
            cryptoCoinsViewModelsState.value = .dataReceived(sortedViewModels)
        }
    }
}


