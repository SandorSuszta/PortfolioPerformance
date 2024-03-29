import UIKit

class PPTextLabel: UILabel {
    
    init(fontSize: CGFloat = 17,
         textColor: UIColor = .label,
         allignment: NSTextAlignment = .center,
         fontWeight: UIFont.Weight = .regular,
         alpha: CGFloat = 1.0
    ){
        super .init(frame: .zero)
        self.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        self.textColor = textColor
        self.textAlignment = allignment
        self.alpha = alpha
        self.minimumScaleFactor = 0.6
        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
