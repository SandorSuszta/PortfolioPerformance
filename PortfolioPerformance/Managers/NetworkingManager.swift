//
//  NetworkingManager.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 04/07/2022.
//

import Foundation

class NetworkingManager {
    static let shared = NetworkingManager()

    private init() {}
    
    private struct Constants {
        static let getGreedAndFearIndexEndpoint = "https://api.alternative.me/fng/"
    }
    
    
    //MARK: - Greed And Fear Index
    public func getGreedAndFearIndex (
        completion: @escaping (Result<GreedAndFearModel, Error>) -> Void
    ){
        guard let url = URL(string: Constants.getGreedAndFearIndexEndpoint) else { fatalError() }
        request(
            url: url,
            expectingType: GreedAndFearModel.self,
            completion: completion)
    }

    //MARK: - Generic Request
    private func request<T:Codable>(
        url: URL?,
        expectingType: T.Type,
        completion: @escaping (Result<T,Error>) -> Void
    ){
        guard let url = url else { return }

        let task = URLSession.shared.dataTask(
            with: url) { data, _, error in
                guard let data = data, error == nil  else { fatalError() }
                
                do {
                    let result = try JSONDecoder().decode(expectingType, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        task.resume()
    }
}
