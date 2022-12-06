
import UIKit

extension UIView {
    public func configureWithShadow(
        shadowColor: UIColor = .systemGray3,
        shadowRadius: CGFloat = 2.0,
        cornerRadius: CGFloat = 16.0
    ){
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = shadowRadius
    }
}
