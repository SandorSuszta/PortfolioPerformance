import UIKit

extension UIView {
    
    func fadeIn(with duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration) {
            self.alpha = 1.0
        }
    }
    
    func fadeOut(with duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0.0
        }
    }
}
