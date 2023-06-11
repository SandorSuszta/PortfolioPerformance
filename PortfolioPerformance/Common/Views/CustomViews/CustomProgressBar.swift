import UIKit

/// A custom progress view that allows customization of its height.
/// Use `CustomProgressView` to create a progress view with a custom height that differs from the standard `UIProgressView`.

class CustomProgressView: UIProgressView {
    var customHeight: CGFloat = 1.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size: CGSize = .init(width: size.width, height: customHeight)
        return size
    }
}
