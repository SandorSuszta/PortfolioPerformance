import Foundation

enum SearchState {
    case idle
    case searching
    case searchResults([SearchResult])
    case noResults
}
