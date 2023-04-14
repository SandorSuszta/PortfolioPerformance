import Foundation

enum PPRouter {
    
    case getAllCryptoData
    case getChartData(forCoinID: String, inDaysInterval: Int)
    case getDataForList(ofIDs: [String])
    case getGlobalData
    case getGreedAndFear
    
    
    var scheme: String {
        switch self {
        case .getAllCryptoData, .getChartData, .getDataForList, .getGlobalData, .getGreedAndFear:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case  .getAllCryptoData, .getChartData, .getDataForList, .getGlobalData:
            return "api.coingecko.com"
        case .getGreedAndFear:
            return "api.alternative.me"
        }
    }
    
    var path: String {
        switch self {
        case .getAllCryptoData, .getDataForList:
            return "/api/v3/coins/markets"
        case .getChartData(let coinID, _):
            return "/api/v3/coins/\(coinID)/market_chart/range"
        case .getGreedAndFear:
            return "/fng/"
        case .getGlobalData:
            return "/api/v3/global"
        }
    }
    
    
    var parameters: [URLQueryItem] {
        switch self {
            
        case .getAllCryptoData:
            return [
                URLQueryItem(name: "vs_currency", value: "usd"),
                URLQueryItem(name: "order", value: "market_cap_desc"),
                URLQueryItem(name: "per_page", value: "500"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "sparkline", value: "false")
            ]
            
        case .getChartData(_, let daysInterval):
            let unixTimeNow = Int(Date().timeIntervalSince1970)
            let unixTimeThen = unixTimeNow - Int(daysInterval)
            
            return [
                URLQueryItem(name: "vs_currency", value: "usd"),
                URLQueryItem(name: "from", value: "\(unixTimeThen)"),
                URLQueryItem(name: "to", value: "\(unixTimeNow)")
            ]
            
        case .getDataForList(let IDs):
            return [
                URLQueryItem(name: "vs_currency", value: "usd"),
                URLQueryItem(name: "ids", value: IDs.joined(separator: ","))
            ]
            
        case .getGreedAndFear, .getGlobalData:
            return []
        }
    }
}
