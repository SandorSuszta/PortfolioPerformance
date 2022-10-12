import UIKit

enum CircularProgressBarType {
    case round
    case gradient
}

class CircularProgressBar: UIView {
    
    public var type: CircularProgressBarType
    public var progress: Float
    public var color: CGColor
    
    private let shapeLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    private let gradient = CAGradientLayer()
    
    //MARK: - Init
    
    init(frame: CGRect, type: CircularProgressBarType, progress: Float, color: CGColor) {
        
        self.type = type
        self.progress = progress
        self.color = color
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Lifecycle
    
    override func layoutSubviews() {
        addProgressBar()
    }
    
    //MARK: - Private methods
    
    private func addProgressBar() {
        
        var circularPath = UIBezierPath()
        
        layer.addSublayer(trackLayer)
        
        switch type {
            
        case .round:
            circularPath = UIBezierPath(
                arcCenter: CGPoint(x: width/2, y: height/2),
                radius: width/2 - 4,
                startAngle: -CGFloat.pi / 2,
                endAngle: CGFloat.pi + CGFloat.pi / 2,
                clockwise: true
            )
            layer.addSublayer(shapeLayer)
            
        case .gradient:
            circularPath = UIBezierPath(
                arcCenter: CGPoint(x: width/2, y: height/2),
                radius: width/2 - 4,
                startAngle: CGFloat.pi - CGFloat.pi / 8,
                endAngle:  2 * CGFloat.pi + CGFloat.pi / 8,
                clockwise: true
            )
            self.addGradient()
        }
        
        //TrackLayer
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.systemGray5.cgColor
        trackLayer.lineWidth = width / 11
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        //BarLayer
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = width / 11
        shapeLayer.strokeEnd = CGFloat(progress)
        shapeLayer.lineCap = CAShapeLayerLineCap.round
    }
    
    private func addGradient() {
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.colors = [
            UIColor.red.cgColor,
            UIColor.pomergranate.cgColor,
            UIColor.carrot.cgColor,
            UIColor.nephritis.cgColor
        ]
        gradient.locations = [
            0.0,
            0.1,
            0.6,
            0.8
        ]
        gradient.mask = shapeLayer
        layer.addSublayer(gradient)
    }
}
