import Foundation

final class MarketViewModel: MarketViewModelOutput, MarketViewModelInput {
    private var marketSortOption: MarketSortOption = .topCaps
    
    // MARK: - Dependencies
    
    private let marketCardContentFactory: MarketCardContentViewModelFactory
    private let marketService: MarketService
    private let greedAndFearService: GreedAndFearService
    
    //MARK: - Init
    
    init(
        marketService: MarketService,
        greedAndFearService: GreedAndFearService,
        marketCardContentFactory: MarketCardContentViewModelFactory
    ) {
        self.marketService = marketService
        self.greedAndFearService = greedAndFearService
        self.marketCardContentFactory = marketCardContentFactory
    }

    // MARK: - Output
    
    lazy var marketCardsViewModels: ObservableObject<[MarketCardContentViewModel]> = ObservableObject(
        value: createLoadingContentViewModels())
    
    var cryptocurrenciesContentViewModel: ObservableObject<CryptoCurrenciesContenViewModel> = ObservableObject(value: .loading)
    
    var errorState: ObservableObject<ErrorStatus> = ObservableObject(value: .noErrors)
    
    //MARK: - Input
    
    func viewDidLoad() {
        loadMarketData()
    }
    
    func viewDidSelectSortOption(_ sortOption: MarketSortOption) {
        marketSortOption = sortOption
    }
    
    // MARK: - Private
    
    private func loadMarketData() {
        loadGreedAndFearIndex()
        getGlobalData()
        loadAllCryptoCurrenciesData(sortedBy: marketSortOption)
    }
    
    private func loadGreedAndFearIndex() {
        
        greedAndFearService.getGreedAndFearData { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                
                let greedAndFearContentViewModel = self.marketCardContentFactory.makeGreedAndFearViewModel(from: response)
                
                self.updateMarketCardsContentViewModels(with: [greedAndFearContentViewModel])
                
            case .failure(let error):
                self.errorState.value = .error(error)
            }
        }
    }
    
    func getGlobalData() {
        
        marketService.getGlobalData { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let globalDataResponse):

                let marketCapCotentViewModel = self.marketCardContentFactory.makeMarketCapViewModel(from: globalDataResponse)
                
                let dominanceContentViewModel = self.marketCardContentFactory.makeBitcoinDominanceViewModel(from: globalDataResponse)
                
                self.updateMarketCardsContentViewModels(with: [
                    marketCapCotentViewModel,
                    dominanceContentViewModel
                ])
                
            case .failure(let error):
                self.errorState.value = .error(error)
            }
        }
    }
    
    private func loadAllCryptoCurrenciesData(sortedBy sortOption: MarketSortOption = .topCaps) {
        marketService.getCryptoCurrenciesData { [weak self] result in
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
                let viewModels = sortedArray.compactMap { CryptoCurrencyItemViewModel(coinModel: $0) }
                
                self.cryptoCoinsViewModelsState.value = .dataReceived(viewModels)
               
                
            case .failure(let error):
                self.errorsStatus.value = .error(error)
            }
        }
    }
    
    ///The function updates market cards with new data, ensuring that the number of cards displayed is equal to the targetCardsCount (which is 3 in this implementation) by adding loading cards if needed.
    
    private func updateMarketCardsContentViewModels(with cardsViewModels: [MarketCardContentViewModel]) {
        var cardsWithItem = marketCardsViewModels.value.filter { card in
                if case .loading = card {
                    return false
                }
                return true
            }

        cardsWithItem.append(contentsOf: cardsViewModels)
        
        let targetCardsCount = 3
        let loadingCardsCountToAdd = max(0, targetCardsCount - cardsWithItem.count)
        
        let loadingCardsToAdd = Array(repeating: MarketCardContentViewModel.loading(id: UUID()), count: loadingCardsCountToAdd)
        
        marketCardsViewModels.value = cardsWithItem + loadingCardsToAdd
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
    
    private func createLoadingContentViewModels() -> [MarketCardContentViewModel] {
        let numberOfViewModels = 3
        return (0..<numberOfViewModels).map { _ in
            marketCardContentFactory.makeLoadingContentViewModel()
        }
    }
    
    private func resetError() {
        errorState.value = .noErrors
    }
}

// MARK: - ErrorAlertDelegate methods

extension MarketViewModel: ErrorAlertDelegate {
    func didPressRetry() {
        resetError()
        loadMarketData()
    }
}
