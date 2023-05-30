import Foundation

enum SearchBarState {
    case searching(resultModels: [SearchResult])
    case emptyWithRecents(recentModels: [SearchResult], trendingModels: [SearchResult])
    case emptyWithoutRecents(trendingModels: [SearchResult])
}
