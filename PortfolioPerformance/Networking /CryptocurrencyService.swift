//import Foundation
//    
//    func getDataFor(IDs: [String], completion: @escaping (Result<[CoinModel], Error>) -> Void) {
//        httpClient.performRequest(
//            url: CryptoEndpoint.getDataForList(IDs: IDs).url,
//            responseModel: [CoinModel].self,
//            completionHandler: completion
//        )
//    }
//    
//    func getChartData(for ID: String, inDaysInterval interval: Int, completion: @escaping (Result<PriceModels, Error>) -> Void) {
//        httpClient.performRequest(
//            url: CryptoEndpoint.getChartData(ID: ID, daysInterval: interval).url,
//            responseModel: PriceModels.self,
//            completionHandler: completion
//        )
//    }
//    
//    func getDetailsData(for ID: String, completion: @escaping (Result<CoinDetails, Error>) -> Void) {
//        httpClient.performRequest(
//            url: CryptoEndpoint.getDetailsData(ID: ID).url,
//            responseModel: CoinDetails.self,
//            completionHandler: completion
//        )
//    }
//    
//    func searchWith(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
//        httpClient.performRequest(
//            url: CryptoEndpoint.search(query: query).url,
//            responseModel: SearchResponse.self,
//            completionHandler: completion
//        )
//    }
//    
//    func getTrendingCoins(completion: @escaping (Result<TrendingResponse, Error>) -> Void) {
//        httpClient.performRequest(
//            url: CryptoEndpoint.getTrendingCrypto.url,
//            responseModel: TrendingResponse.self,
//            completionHandler: completion
//        )
//    }
//}
//
