import Foundation

enum PPRouter {
    
    case getAllCryptoData
    case getChartData(ID: String, daysInterval: Int)
    case getDataForList(IDs: [String])
    case getDetailsData(ID: String)
    case getGlobalData
    case getGreedAndFear
    case getTrendingCrypto
    case search(query: String)
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        switch self {
        case  .getAllCryptoData, .getChartData, .getDetailsData, .getDataForList, .getGlobalData, .getTrendingCrypto, .search:
            return "api.coingecko.com"
        case .getGreedAndFear:
            return "api.alternative.me"
        }
    }
    
    var path: String {
        switch self {
        case .getAllCryptoData, .getDataForList:
            return "/api/v3/coins/markets"
        case .getChartData(let ID, _):
            return "/api/v3/coins/\(ID)/market_chart/range"
        case .getDetailsData(let ID):
            return "/api/v3/coins/\(ID)"
        case .getGreedAndFear:
            return "/fng/"
        case .getGlobalData:
            return "/api/v3/global"
        case .getTrendingCrypto:
            return "/api/v3/search/trending"
        case .search:
            return "/api/v3/search"
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
            let unixTimeThen = unixTimeNow - Int(86400 * daysInterval)
            
            return [
                URLQueryItem(name: "vs_currency", value: "usd"),
                URLQueryItem(name: "from", value: "\(unixTimeThen)"),
                URLQueryItem(name: "to", value: "\(unixTimeNow)")
            ]
            
        case .getDetailsData:
            return [
                URLQueryItem(name: "localization", value: "false"),
                URLQueryItem(name: "tickers", value: "false"),
                URLQueryItem(name: "market_data", value: "true"),
                URLQueryItem(name: "community_data", value: "false"),
                URLQueryItem(name: "developer_data", value: "false"),
                URLQueryItem(name: "sparkline", value: "false")
            ]
            
        case .getDataForList(let IDs):
            return [
                URLQueryItem(name: "vs_currency", value: "usd"),
                URLQueryItem(name: "ids", value: IDs.joined(separator: ","))
            ]
            
        case .search(let query):
            return [URLQueryItem(name: "query", value: query)]
            
        case .getGreedAndFear, .getGlobalData, .getTrendingCrypto:
            return []
        }
    }
}
