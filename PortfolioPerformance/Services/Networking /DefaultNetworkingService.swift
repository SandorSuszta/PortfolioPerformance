import UIKit

protocol NetworkingServiceProtocol {
    func getGreedAndFearData (completion: @escaping (Result<GreedAndFear, PPError>) -> Void)
    func getCryptoCurrenciesData(completion: @escaping (Result<[CoinModel], PPError>) -> Void)
    func getGlobalData(completion: @escaping (Result<GlobalDataResponse, PPError>) -> Void)
    func getDataFor(IDs: [String], completion: @escaping (Result<[CoinModel], PPError>) -> Void)
    func getChartData(for ID: String, inDaysInterval interval: Int, completion: @escaping (Result<PriceModels, PPError>) -> Void)
    func getDetailsData(for ID: String, completion: @escaping (Result<CoinDetails, PPError>) -> Void)
    func searchWith(query: String, completion: @escaping (Result<SearchResponse, PPError>) -> Void)
    func getTrendingCoins(completion: @escaping (Result<TrendingResponse, PPError>) -> Void)
}

struct DefaultNetworkingService: NetworkingServiceProtocol {

    //MARK: - Greed And Fear Index done
    func getGreedAndFearData (completion: @escaping (Result<GreedAndFear, PPError>) -> Void) {
        request(
            router: .getGreedAndFear,
            expectingType: GreedAndFear.self,
            completion: completion
        )
    }
    
    //MARK: - Total Market Cap done
    func getGlobalData(completion: @escaping (Result<GlobalDataResponse, PPError>) -> Void) {
        request(
            router: .getGlobalData,
            expectingType: GlobalDataResponse.self,
            completion: completion
        )
    }
    
    //MARK: - All Crypto Data done
    func getCryptoCurrenciesData(completion: @escaping (Result<[CoinModel], PPError>) -> Void) {
        request(
            router: .getAllCryptoData,
            expectingType: [CoinModel].self,
            completion: completion
        )
    }
    
    //MARK: - Crypto Data For Watchlist done
    func getDataFor(
        IDs: [String],
        completion: @escaping (Result<[CoinModel], PPError>) -> Void
    ){
        request(
            router: .getDataForList(IDs: IDs),
            expectingType: [CoinModel].self,
            completion: completion
        )
    }
    
    //MARK: - Chart Data done
    func getChartData(
        for ID: String,
        inDaysInterval interval: Int,
        completion: @escaping (Result<PriceModels, PPError>) -> Void
    ){
        request(
            router: .getChartData(ID: ID, daysInterval: interval),
            expectingType: PriceModels.self,
            completion: completion
        )
    }
    
    //MARK: - Data by ID done
    func getDetailsData(
        for ID: String,
        completion: @escaping (Result<CoinDetails, PPError>) -> Void
    ){
        request(
            router: .getDetailsData(ID: ID),
            expectingType: CoinDetails.self,
            completion: completion
        )
    }
    
    //MARK: - Search
    func searchWith(
        query: String,
        completion: @escaping (Result<SearchResponse, PPError>) -> Void
    ){
        request(
            router: .search(query: query),
            expectingType: SearchResponse.self,
            completion: completion
        )
    }
    
    //MARK: - Trending
    func getTrendingCoins(
        completion: @escaping (Result<TrendingResponse, PPError>) -> Void
    ){
        request(
            router: .getTrendingCrypto,
            expectingType: TrendingResponse.self,
            completion: completion
        )
    }
}

//MARK: - Private 
private extension DefaultNetworkingService {
    
    func request<T:Codable>(
        router: PPRouter,
        expectingType: T.Type,
        completion: @escaping (Result<T, PPError>) -> Void
    ){
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        
        guard let url = components.url else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(
            with: url) { data, _, error in
                guard let data = data, error == nil  else {
                    completion(.failure(.netwokingError))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(expectingType, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        task.resume()
    }
}
