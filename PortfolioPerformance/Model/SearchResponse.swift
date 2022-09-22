//
//  SearchResponse.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 12/05/2022.
//

import Foundation

/*{ API response example
  "coins": [
    {
      "id": "bitcoin",
      "name": "Bitcoin",
      "symbol": "BTC",
      "market_cap_rank": 1,
      "thumb": "https://assets.coingecko.com/coins/images/1/thumb/bitcoin.png",
      "large": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png"
    }*/

struct SearchResponse: Codable {
    let coins: [SearchResult]
}

struct SearchResult: Codable {
    let id: String
    let name: String
    let symbol: String
    let large: String
    let imageData: Data?
}
