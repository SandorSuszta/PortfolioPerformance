import UIKit

class PPRoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = false
        layer.cornerRadius = frame.height/2
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3.0
    }
}
