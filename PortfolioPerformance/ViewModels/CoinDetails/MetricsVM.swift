import Foundation

struct MetricsViewModel {
    public var name: String
    public var symbol: String
    public var imageUrl: String
    public var imageData: Data? = nil
    public var currentPrice: String
    public var athPrice: String
    public var athChangePercentage: String
    public var athDate: String
    public var marketCap: String
    public var volume: String
    public var circulatingSupply: String
    public var totalSupply: String
    public var maxSupply:String
    public var isFavourite: Bool = false
    
    init (model: SingleCoinModel) {
        self.name = model.name
        self.symbol = model.symbol
        self.imageUrl = model.image.large
        self.currentPrice = .priceString(from: model.marketData.currentPrice["usd"] ?? 0)
        self.athPrice = .priceString(from: model.marketData.ath["usd"] ?? 0)
        self.athChangePercentage = .percentageString(from: model.marketData.athChangePercentage["usd"] ?? 0)
        self.athDate = model.marketData.athDate["usd"] ?? "N/A"
        self.marketCap = .bigNumberString(from: model.marketData.marketCap["usd"] ?? 0)
        self.volume = .bigNumberString(from: model.marketData.totalVolume["usd"] ?? 0, style: .decimal)
        self.circulatingSupply = ""
        self.totalSupply = ""
        self.maxSupply = ""
    }
}
