//
//  CryptoCurrencyTableCellViewModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 07/07/2022.
//

import Foundation

class MarketTableCellViewModel {

    public let coinModel: CoinModel
    
    public var name: String {
        coinModel.name
    }
    public var symbol: String {
        coinModel.symbol.uppercased()
    }
    public var imageUrl: String {
        coinModel.image
    }
    public var imageData: Data?
    
    public var currentPrice: String {
        .priceString(from: coinModel.currentPrice)
    }
    public var priceChange24H: String {
        .priceString(from: coinModel.priceChange24H ?? 0)
    }
    public var priceChangePercentage24H: String {
        .percentageString(from: coinModel.priceChangePercentage24H ?? 0)
    }
    
    public var isFavourite: Bool = false
    
    public var isPriceChangeNegative: Bool {
        coinModel.priceChange24H ?? 0 > 0 ? false : true
    }
    
    //MARK: - Init
    init (coinModel: CoinModel) {
        self.coinModel = coinModel
    }
}
