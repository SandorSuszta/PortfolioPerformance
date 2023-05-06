import UIKit

protocol Coordinator: AnyObject {
    var services: Services { get }
    
    func start()
}
