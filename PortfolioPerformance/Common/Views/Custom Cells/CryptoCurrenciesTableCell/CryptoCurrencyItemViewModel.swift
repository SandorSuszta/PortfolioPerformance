import Foundation

final class CryptoCurrencyItemViewModel {

    let coinModel: CoinModel
    
    var name: String {
        coinModel.name
    }
    
    var symbol: String {
        coinModel.symbol.uppercased()
    }
    
    var imageUrl: String {
        coinModel.image
    }
    
    var imageData: Data?
    
    var currentPrice: String {
        .priceString(from: coinModel.currentPrice)
    }
    
    var priceChange24H: String {
        .priceString(from: coinModel.priceChange24H ?? 0)
    }
    
    var priceChangePercentage24H: String {
        .percentageString(from: coinModel.priceChangePercentage24H ?? 0)
    }
    
    var isFavourite: Bool = false
    
    var isPriceChangeNegative: Bool {
        coinModel.priceChange24H ?? 0 > 0 ? false : true
    }
    
    //MARK: - Init
    init (coinModel: CoinModel) {
        self.coinModel = coinModel
    }
}

extension CryptoCurrencyItemViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(coinModel)
    }
    
    static func ==(lhs: CryptoCurrencyItemViewModel, rhs: CryptoCurrencyItemViewModel) -> Bool {
        return lhs.coinModel == rhs.coinModel
    }
}
