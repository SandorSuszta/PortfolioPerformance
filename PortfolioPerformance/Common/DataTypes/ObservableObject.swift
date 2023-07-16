import Foundation

final class ObservableObject<T> {
    
    var value: ObservableValue<T> {
        didSet{
            listener?(value)
        }
    }
    
    var listener: ((ObservableValue<T>) -> Void)?
    
    init(value: ObservableValue<T>) {
        self.value = value
    }
    
   func bind(listener: @escaping (ObservableValue<T>) -> Void) {
        listener(value)
        self.listener = listener
    }
}


enum ObservableValue<T> {
    case noData
    case loading
    case data(T)
}
