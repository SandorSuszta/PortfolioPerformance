import Foundation

enum PPRouter {
    
    case getGreedAndFear
    case getGlobalData
    case getListData
    case getChartData
    
    
    var sceme: String {
        switch self {
        case .getGreedAndFear, .getGlobalData, .getListData, .getChartData:
            return "https:/"
        }
    }
    
    var host: String {
        switch self {
        case .getGlobalData, .getListData, .getChartData:
            return "/api.coingecko.com"
        case .getGreedAndFear:
            return "/api.alternative.me"
        }
    }
}
