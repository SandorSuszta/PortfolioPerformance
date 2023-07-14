import Foundation

enum Cell<T: Hashable>: Hashable {
    case item(T)
    case loading(index: Int)
}
