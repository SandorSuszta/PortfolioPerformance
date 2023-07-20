import Foundation

enum MetricsViewModelState {
    case loading
    case dataReceived(MetricsViewModel)
}

struct MetricsViewModel {
    let model: CoinDetails
    
    let name: String
    let symbol: String
    let imageUrl: String
    let imageData: Data? = nil
    let currentPrice: String
    let athPrice: String
    let athChangePercentage: String
    let athDate: String
    let marketCap: String
    var marketCapRank: String
    let volume: String
    let circulatingSupply: String
    let totalSupply: String
    let maxSupply:String
    let isFavourite: Bool = false
    
    init (model: CoinDetails) {
        self.model = model
        self.name = model.name
        self.symbol = model.symbol
        self.imageUrl = model.image.large
        self.currentPrice = .priceString(from: model.marketData.currentPrice["usd"] ?? 0)
        self.athPrice = .priceString(from: model.marketData.ath["usd"] ?? 0)
        self.athChangePercentage = .percentageString(from: model.marketData.athChangePercentage["usd"] ?? 0)
        self.athDate = model.marketData.athDate["usd"] ?? "N/A"
        self.marketCap = .bigNumberString(from: model.marketData.marketCap["usd"] ?? 0)
        self.marketCapRank = "#\(model.marketData.marketCapRank ?? 0)"
        self.volume = .bigNumberString(from: model.marketData.totalVolume["usd"] ?? 0, style: .decimal)
        self.circulatingSupply = ""
        self.totalSupply = ""
        self.maxSupply = ""
        
        if let marketCapRank = model.marketData.marketCapRank {
            self.marketCapRank = "#\(marketCapRank)"
        } else {
            self.marketCapRank = "N/A"
        }
    }
}
