import UIKit

class CustomSegmentedControl: UISegmentedControl {
    
    //MARK: - Init
    
    init(items: [Any]?, defaultColor: UIColor) {
        super .init(items: items)
        configure(withColor: defaultColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //set rounded corners for segments
        for (index, subview) in subviews.enumerated() {
            if ((subviews[index] as? UIImageView) != nil) && index == selectedSegmentIndex {
                subview.layer.cornerRadius =  subview.frame.height / 2
                subview.clipsToBounds = true
            }
        }
    }

    //MARK: - Private methods
    
    private func configure(withColor color: UIColor) {
        selectedSegmentIndex = 0
        
        setBackgroundImage(imageWithColor(color: color), for: .selected, barMetrics: .default)
        setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.darkGray], for: .normal)
    }
    
    //create a 1x1 image with given color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
    public func updateBackgroundColor() {
        switch selectedSegmentIndex {
        case 0:
            setBackgroundImage(imageWithColor(color: .emerald), for: .selected, barMetrics: .default)
        case 1:
            setBackgroundImage(imageWithColor(color: .pomergranate), for: .selected, barMetrics: .default)
        case 2:
            setBackgroundImage(imageWithColor(color: .PPblue), for: .selected, barMetrics: .default)
        default:
            fatalError()
        }
    }
}
