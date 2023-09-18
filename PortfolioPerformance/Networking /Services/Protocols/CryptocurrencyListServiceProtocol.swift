//
//  CryptocurrencyListServiceProtocol.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 18/09/2023.
//

import Foundation

protocol CryptocurrencyListServiceProtocol {
    func getDataFor(IDs: [String],
                    completion: @escaping (Result<[CoinModel], Error>) -> Void)
}
