import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    
    var services: Services { get }
    
    func start()
}

extension Coordinator {
    func showAlert(message: String) { }
    
    
}
