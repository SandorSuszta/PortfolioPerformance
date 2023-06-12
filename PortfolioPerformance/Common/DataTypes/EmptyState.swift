import Foundation

enum EmptyState {
    case noSearchResults
    case noFavourites
    
    var imageName: String {
        switch self {
        case .noFavourites:
            return "noFavourites"
        case .noSearchResults:
            return "noResult"
        }
    }
    
    var title: String {
        switch self {
        case .noFavourites:
            return "Favourite list is empty"
        case .noSearchResults:
            return "Sorry, nothing found"
        }
    }
}
