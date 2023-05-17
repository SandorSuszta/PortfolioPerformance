import Foundation

struct SearchResponse: Codable {
    let coins: [SearchResult]
}

struct TrendingResponse: Codable {
    let coins: [Coin]
}

struct Coin: Codable {
    let item: SearchResult
}

struct SearchResult: Codable, Hashable, Identifiable, CoinRepresenatable {
    let id: String
    let name: String
    let symbol: String
    let image: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case image = "large"
    }
}
