//
//  SearchVM.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 12/10/2022.
//

import Foundation

class SearchScreenViewModel {
    
    //MARK: - Observable properties
    
    var defaultCellModels: ObservableObject<[[SearchResult]]> = ObservableObject(value: [[],[]])
    
    var searchResultCellModels: ObservableObject<[SearchResult]> = ObservableObject(value: nil)
    
    var errorMessage: ObservableObject<String> = ObservableObject(value: nil)
    
    //MARK: - Init
    
    init() {
        updateRecentSearches()
        getTrendingCoinsModels()
    }
    
    //MARK: - Public methods
    
    func updateRecentSearches() {
        
        if !UserDefaultsService.shared.recentSearchesIDs.isEmpty {
            getRecentSearchesModels()
        }
    }
    
    func updateSearchResults(query: String) {
        
        NetworkingService.shared.searchWith(query: query) { result in
            
            switch result {
            case.success(let response):
                self.searchResultCellModels.value = self.sortedByHasPrefix(response.coins, query: query)
                
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    func clearSearchModels() {
        self.searchResultCellModels.value = nil
    }
    
    func clearRecentSearches() {
        defaultCellModels.value?[0] = []
    }
    
    //MARK: - Private methods

    private func getRecentSearchesModels() {
        
        guard !UserDefaultsService.shared.recentSearchesIDs.isEmpty else { return }
        
        NetworkingService.shared.requestDataForList(
            list: UserDefaultsService.shared.recentSearchesIDs
        ){
            result in
            
            switch result {
            case .success(let coinModels):
                
                var recentSearchesModels: [SearchResult] = coinModels.compactMap {
                    SearchResult(
                        id: $0.id,
                        name: $0.name,
                        symbol: $0.symbol,
                        large: $0.image
                    )
                }
                
                let list = UserDefaultsService.shared.recentSearchesIDs
                
                //Use the same order as in saved list
                recentSearchesModels.sort {
                    list.firstIndex(of: $0.id) ?? 0 > list.firstIndex(of: $1.id) ?? 0
                }
                
                self.defaultCellModels.value?[0] = recentSearchesModels
                
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    private func getTrendingCoinsModels() {
        
        NetworkingService.shared.requestTrendingCoins { result in

            switch result {
            case .success(let response):
                let trendingCoins: [SearchResult] = response.coins.compactMap {
                    $0.item
                }
                self.defaultCellModels.value?[1] = trendingCoins
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    private func sortedByHasPrefix(_ array: [SearchResult], query: String) -> [SearchResult] {
        let searchResults = array.sorted { (result1, result2) -> Bool in
            
            let isPrefix1 = result1.symbol.lowercased().hasPrefix(query.lowercased())
            let isPrefix2 = result2.symbol.lowercased().hasPrefix(query.lowercased())
            
            return isPrefix1 && !isPrefix2 ? true
            : !isPrefix1 && isPrefix2 ? false
            : result1.symbol < result2.symbol
        }
        return Array(searchResults.prefix(6))
    }
}
