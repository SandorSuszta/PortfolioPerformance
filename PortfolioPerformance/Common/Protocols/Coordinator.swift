import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var services: Services { get }
    
    func start()
}
