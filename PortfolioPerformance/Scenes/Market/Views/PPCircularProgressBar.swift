import UIKit

/// A circular progress bar.
/// Shows a filled portion that represents the progressvalue.
final class PPCircularProgressBar: UIView {
    
    //MARK: - Properties
    
    public let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    
    public var progressColor: UIColor = UIColor.clear {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
            trackLayer.strokeColor = progressColor.withAlphaComponent(0.1).cgColor
        }
    }
    
    public var progressValue: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = progressValue
        }
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupProgressBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutProgressBar()
    }
    
    //MARK: - API
    
    func setProgress(_ progress: CGFloat) {
        progressLayer.strokeEnd = progress
    }
    
    //MARK: - Private methods
    
    private func setupProgressBar() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
        translatesAutoresizingMaskIntoConstraints = false
        
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.tertiarySystemBackground.cgColor
        trackLayer.lineCap = .round
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
    }
    
    private func layoutProgressBar() {
        let lineWidth = bounds.height / 9
        let radius = min(bounds.height, bounds.width) / 2 - lineWidth / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: CGFloat.pi + CGFloat.pi / 2,
            clockwise: true
        )
        trackLayer.path = path.cgPath
        trackLayer.lineWidth = lineWidth
        progressLayer.path = path.cgPath
        progressLayer.lineWidth = lineWidth
    }
}
