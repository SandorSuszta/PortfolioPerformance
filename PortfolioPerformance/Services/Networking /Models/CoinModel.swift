//
//  CoinModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 09/02/2022.
//

import Foundation

struct CoinModel: Codable, Identifiable, CoinRepresenatable {
    
    let id, symbol, name: String
    let image: String
    var imageData: Data?
    let currentPrice: Double
    let marketCapRank: Double?
    let marketCap, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H: Double?
    let priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    var isFavourite: Bool? = false
    
    private enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
    }
}

extension CoinModel: Hashable {
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
    static func == (lhs: CoinModel, rhs: CoinModel) -> Bool {
        return lhs.id == rhs.id
    }
}
