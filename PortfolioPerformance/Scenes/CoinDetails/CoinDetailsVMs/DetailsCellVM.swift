import Foundation

enum DetailsCellsViewModelsState {
    case loading
    case dataReceived([DetailsCellsViewModel])
}

struct DetailsCellsViewModel {
    let name: String
    let value: String
    
    init(type: DetailCell, value: String) {
        self.name = type.rawValue
        self.value = value
    }
}
