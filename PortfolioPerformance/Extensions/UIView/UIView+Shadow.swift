
import UIKit

extension UIView {
    public func configureWithShadow(
        shadowColor: UIColor = .black,
        shadowRadius: CGFloat = 2.0,
        cornerRadius: CGFloat = 10
    ){
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = shadowRadius
    }
}
