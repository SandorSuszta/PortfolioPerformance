import UIKit

class PPSegmentedControl: UISegmentedControl {
    
    //MARK: - Init
    
    init(items: [Any]?, backgroundColor: UIColor) {
        super .init(items: items)
        setupAppearance(withBackgroundColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setRoundedCornersForSelectedSegment()
    }
    
    // MARK: - API
    
    func setBackgroundColor(_ color: UIColor) {
            setBackgroundImage(makeImageWithColor(color), for: .selected, barMetrics: .default)
    }

    //MARK: - Private methods
    
    private func setupAppearance(withBackgroundColor color: UIColor) {
        selectedSegmentIndex = 0
        
        setBackgroundImage(makeImageWithColor(color), for: .selected, barMetrics: .default)
        setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.darkGray], for: .normal)
    }
    
    private func setRoundedCornersForSelectedSegment() {
        guard let selectedImageView = subviews[selectedSegmentIndex] as? UIImageView else {
            return
        }
        selectedImageView.layer.cornerRadius = selectedImageView.frame.height / 2
        selectedImageView.clipsToBounds = true
        //        for (index, subview) in subviews.enumerated() {
        //            if ((subviews[index] as? UIImageView) != nil) && index == selectedSegmentIndex {
        //                subview.layer.cornerRadius =  subview.frame.height / 2
        //                subview.clipsToBounds = true
        //            }
        //        }
    }
    
    ///Creates a 1x1 image with given color to use as a background of the segment
    private func makeImageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
