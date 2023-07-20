import Foundation

enum SearchState {
    case initialLoading
    case idle
    case searching
    case searchResults([SearchResult])
}
