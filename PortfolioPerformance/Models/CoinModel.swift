//
//  CoinModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 09/02/2022.
//

import Foundation

struct CoinModel: Identifiable, Codable {
    
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
    
    enum CodingKeys: String, CodingKey {
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
    
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CoinModel.CodingKeys> = try decoder.container(keyedBy: CoinModel.CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: CoinModel.CodingKeys.id)
        self.symbol = try container.decode(String.self, forKey: CoinModel.CodingKeys.symbol)
        self.name = try container.decode(String.self, forKey: CoinModel.CodingKeys.name)
        self.image = try container.decode(String.self, forKey: CoinModel.CodingKeys.image)
        self.currentPrice = try container.decode(Double.self, forKey: CoinModel.CodingKeys.currentPrice)
        self.marketCap = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.marketCap)
        self.marketCapRank = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.marketCapRank)
        self.fullyDilutedValuation = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.fullyDilutedValuation)
        self.totalVolume = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.totalVolume)
        self.high24H = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.high24H)
        self.low24H = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.low24H)
        self.priceChange24H = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.priceChange24H)
        self.priceChangePercentage24H = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.priceChangePercentage24H)
        self.marketCapChange24H = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.marketCapChange24H)
        self.marketCapChangePercentage24H = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.marketCapChangePercentage24H)
        self.circulatingSupply = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.circulatingSupply)
        self.totalSupply = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.totalSupply)
        self.maxSupply = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.maxSupply)
        self.ath = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.ath)
        self.athChangePercentage = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.athChangePercentage)
        self.athDate = try container.decodeIfPresent(String.self, forKey: CoinModel.CodingKeys.athDate)
        self.atl = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.atl)
        self.atlChangePercentage = try container.decodeIfPresent(Double.self, forKey: CoinModel.CodingKeys.atlChangePercentage)
        self.atlDate = try container.decodeIfPresent(String.self, forKey: CoinModel.CodingKeys.atlDate)
        self.lastUpdated = try container.decodeIfPresent(String.self, forKey: CoinModel.CodingKeys.lastUpdated)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<CoinModel.CodingKeys> = encoder.container(keyedBy: CoinModel.CodingKeys.self)
        
        try container.encode(self.id, forKey: CoinModel.CodingKeys.id)
        try container.encode(self.symbol, forKey: CoinModel.CodingKeys.symbol)
        try container.encode(self.name, forKey: CoinModel.CodingKeys.name)
        try container.encode(self.image, forKey: CoinModel.CodingKeys.image)
        try container.encode(self.currentPrice, forKey: CoinModel.CodingKeys.currentPrice)
        try container.encodeIfPresent(self.marketCap, forKey: CoinModel.CodingKeys.marketCap)
        try container.encodeIfPresent(self.marketCapRank, forKey: CoinModel.CodingKeys.marketCapRank)
        try container.encodeIfPresent(self.fullyDilutedValuation, forKey: CoinModel.CodingKeys.fullyDilutedValuation)
        try container.encodeIfPresent(self.totalVolume, forKey: CoinModel.CodingKeys.totalVolume)
        try container.encodeIfPresent(self.high24H, forKey: CoinModel.CodingKeys.high24H)
        try container.encodeIfPresent(self.low24H, forKey: CoinModel.CodingKeys.low24H)
        try container.encodeIfPresent(self.priceChange24H, forKey: CoinModel.CodingKeys.priceChange24H)
        try container.encodeIfPresent(self.priceChangePercentage24H, forKey: CoinModel.CodingKeys.priceChangePercentage24H)
        try container.encodeIfPresent(self.marketCapChange24H, forKey: CoinModel.CodingKeys.marketCapChange24H)
        try container.encodeIfPresent(self.marketCapChangePercentage24H, forKey: CoinModel.CodingKeys.marketCapChangePercentage24H)
        try container.encodeIfPresent(self.circulatingSupply, forKey: CoinModel.CodingKeys.circulatingSupply)
        try container.encodeIfPresent(self.totalSupply, forKey: CoinModel.CodingKeys.totalSupply)
        try container.encodeIfPresent(self.maxSupply, forKey: CoinModel.CodingKeys.maxSupply)
        try container.encodeIfPresent(self.ath, forKey: CoinModel.CodingKeys.ath)
        try container.encodeIfPresent(self.athChangePercentage, forKey: CoinModel.CodingKeys.athChangePercentage)
        try container.encodeIfPresent(self.athDate, forKey: CoinModel.CodingKeys.athDate)
        try container.encodeIfPresent(self.atl, forKey: CoinModel.CodingKeys.atl)
        try container.encodeIfPresent(self.atlChangePercentage, forKey: CoinModel.CodingKeys.atlChangePercentage)
        try container.encodeIfPresent(self.atlDate, forKey: CoinModel.CodingKeys.atlDate)
        try container.encodeIfPresent(self.lastUpdated, forKey: CoinModel.CodingKeys.lastUpdated)
    }
}
