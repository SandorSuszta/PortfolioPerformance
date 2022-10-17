//
//  SearchVM.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 12/10/2022.
//

import Foundation

class SearchScreenViewModel {
    
    //MARK: - Observable properties
    
    var defaultCellModels: ObservableObject<[[SearchResult]]> = ObservableObject(value: [])
    
    var searchResultCellModels: ObservableObject<[SearchResult]> = ObservableObject(value: nil)
    
    var errorMessage: ObservableObject<String> = ObservableObject(value: nil)
    
    //MARK: - Init
    
    init() {
        updateRecentSearches()
        getTrendingCoinsModels()
    }
    
    //MARK: - Public methods
    
    func updateRecentSearches() {
        
        if !UserDefaultsManager.shared.recentSearchesIDs.isEmpty {
            getRecentSearchesModels()
        }
    }
    
    func updateSearchResults(query: String) {
        
        NetworkingManager.shared.searchWith(query: query) { result in
            
            switch result {
            case.success(let response):
                self.searchResultCellModels.value = Array(response.coins.prefix(5))
                
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    func clearSearchModels() {
        self.searchResultCellModels.value = nil
    }
    
    func clearRecentSearches() {
        defaultCellModels.value?.remove(at: 0)
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
               
                var recentSearchesModels: [SearchResult] = coinModels.compactMap {
                    SearchResult(
                        id: $0.id,
                        name: $0.name,
                        symbol: $0.symbol,
                        large: $0.image
                    )
                }
                
                let list = UserDefaultsManager.shared.recentSearchesIDs
                
                //Use the same order as in saved list
                recentSearchesModels.sort {
                    list.firstIndex(of: $0.id) ?? 0 > list.firstIndex(of: $1.id) ?? 0
                }
                
                if self.defaultCellModels.value?.count == 2 {
                    //Update recent search models
                    self.defaultCellModels.value?[0] = recentSearchesModels
                } else {
                    //Insert recent search models before trending coin models
                    self.defaultCellModels.value?.insert(recentSearchesModels, at: 0)
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
                self.defaultCellModels.value?.append(trendingCoins)
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
}
