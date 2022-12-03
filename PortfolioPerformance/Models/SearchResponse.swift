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

struct SearchResult: Codable {
    let id: String
    let name: String
    let symbol: String
    let large: String
}
