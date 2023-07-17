import Foundation

final class ObservableObject<T> {
    
    var value: T {
        didSet{
            listener?(value)
        }
    }
    
    var listener: ((T) -> Void)?
    
    init(value: T) {
        self.value = value
    }
    
   func bind(listener: @escaping (T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
