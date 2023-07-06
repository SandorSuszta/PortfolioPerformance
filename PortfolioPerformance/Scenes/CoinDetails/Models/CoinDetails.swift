import Foundation

struct CoinDetails: Codable {
    let id, symbol, name: String
    let welcomeDescription: Description
    let image: Image
    let marketCapRank: Int?
    let marketData: MarketData
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case welcomeDescription = "description"
        case image
        case marketCapRank = "market_cap_rank"
        case marketData = "market_data"
    }
}

    // MARK: - Image

struct Image: Codable {
    let thumb, small, large: String
}

    // MARK: - MarketData

struct MarketData: Codable {
    let currentPrice: [String: Double]
    let ath, athChangePercentage: [String: Double]
    let athDate: [String: String]
    let marketCap: [String: Double]
    let marketCapRank: Int?
    let fullyDilutedValuation, totalVolume, high24H, low24H: [String: Double]
    let priceChange24H, priceChangePercentage24H, priceChangePercentage7D, priceChangePercentage14D: Double
    let priceChangePercentage30D, priceChangePercentage60D, priceChangePercentage200D, priceChangePercentage1Y: Double
    let marketCapChange24H, marketCapChangePercentage24H: Double
    let totalSupply, maxSupply, circulatingSupply: Double?
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case priceChangePercentage7D = "price_change_percentage_7d"
        case priceChangePercentage14D = "price_change_percentage_14d"
        case priceChangePercentage30D = "price_change_percentage_30d"
        case priceChangePercentage60D = "price_change_percentage_60d"
        case priceChangePercentage200D = "price_change_percentage_200d"
        case priceChangePercentage1Y = "price_change_percentage_1y"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case circulatingSupply = "circulating_supply"
    }
}

    // MARK: - Description

struct Description: Codable {
    let en: String
}
