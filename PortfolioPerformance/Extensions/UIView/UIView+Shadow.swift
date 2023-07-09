
import UIKit

extension UIView {
    public func addShadow(
        shadowColor: UIColor = .lightGray,
        shadowRadius: CGFloat = 5.0,
        cornerRadius: CGFloat = 16
    ){
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = shadowRadius
    }
}
