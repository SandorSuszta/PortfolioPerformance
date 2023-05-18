import UIKit

extension UIView {
    func fadeIn(withDuration duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            self.alpha = 1.0
        }
    }
    
    func fadeOut(with duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0.0
        }
    }
}

extension UIImageView {
    
    func fadeIn(_ image: UIImage, withDuration duration: TimeInterval = 0.5) {
        self.alpha = 0
        self.image = image
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            self.alpha = 1.0
        }
    }
}
