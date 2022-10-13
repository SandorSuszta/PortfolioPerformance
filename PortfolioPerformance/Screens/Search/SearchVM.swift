//
//  SearchVM.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 12/10/2022.
//

import Foundation

class SearchScreenViewModel {
    
    //MARK: - Observable properties
    
    public var emptySearchCellModels: ObservableObject<[[SearchResult]]> = ObservableObject(value: [])
    
    public var searchResultCellModels: ObservableObject<[SearchResult]> = ObservableObject(value: nil)
    
    public var errorMessage: ObservableObject<String> = ObservableObject(value: nil)
    
    //MARK: - Init
    
    init() {
        updateRecentSearches()
        getTrendingCoinsModels()
    }
    
    //MARK: - Public methods
    
    public func updateRecentSearches() {
        
        if !UserDefaultsManager.shared.recentSearchesIDs.isEmpty {
            getRecentSearchesModels()
        }
    }
    
    public func updateSearchResults(query: String) {
        
        NetworkingManager.shared.searchWith(query: query) { result in
            
            switch result {
            case.success(let response):
                self.searchResultCellModels.value = Array(response.coins.prefix(5))
                
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    public func clearSearchModels() {
        self.searchResultCellModels.value = nil
    }
    
    //MARK: - Private methods

    private func getRecentSearchesModels() {
        
        guard !UserDefaultsManager.shared.recentSearchesIDs.isEmpty else { return }
        
        NetworkingManager.shared.requestDataForList(
            list: UserDefaultsManager.shared.recentSearchesIDs
        ){
            result in
            
            switch result {
            case .success(let coinModels):
                let recentSearchesModels: [SearchResult] = coinModels.compactMap {
                    SearchResult(
                        id: $0.id,
                        name: $0.name,
                        symbol: $0.symbol,
                        large: $0.image
                    )
                }
                
                if self.emptySearchCellModels.value?.count == 2 {
                    self.emptySearchCellModels.value?[0] = recentSearchesModels
                } else {
                    self.emptySearchCellModels.value?.insert(recentSearchesModels, at: 0)
                }
                
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    private func getTrendingCoinsModels() {
        
        NetworkingManager.shared.requestTrendingCoins { result in

            switch result {
            case .success(let response):
                let trendingCoins: [SearchResult] = response.coins.compactMap {
                    $0.item
                }
                self.emptySearchCellModels.value?.append(trendingCoins)
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
}
