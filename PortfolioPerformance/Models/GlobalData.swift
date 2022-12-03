import Foundation

struct GlobalDataResponse: Codable {
    let data: GlobalData
}

struct GlobalData: Codable {
    
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    //TODO: - Implement
    static func calculateDominanceChange(todayDominance: Double, totalMarketCap: Double, totalMarketCapChange: Double, btcMarketCap: Double, btcMarketCapChange: Double) -> Double {
        
        var yesterdayTotalMarketCap: Double {
            totalMarketCap/(1 + totalMarketCapChange/100)
        }
        var yesterdayBtcMarketCap: Double {
            btcMarketCap - btcMarketCapChange
        }
        var yesterdayDominance: Double {
            (yesterdayBtcMarketCap/yesterdayTotalMarketCap) * 100
        }
        return todayDominance - yesterdayDominance
    }
}
