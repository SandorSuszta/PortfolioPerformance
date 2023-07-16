import Foundation

enum CellState<T: Hashable>: Hashable {
    case data(T)
    case loading(index: Int)
}
