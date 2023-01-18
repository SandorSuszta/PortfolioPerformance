import UIKit

enum NumberOfSegments: Int {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
}

class PPSegmentedProgressBar: UIView {
    
    //MARK: - Ptoperties
    
    private var segmentsTrackLayers: [CAShapeLayer] = []
    private var segmentsProgressLayers: [CAShapeLayer] = []
    private let numberOfSegments: NumberOfSegments
    private let startAngle: CGFloat
    private let endAnle: CGFloat
    private let progressBarLength: CGFloat
    private let segmentLength: CGFloat
    private let paddingBetweenSegments: CGFloat
    private let segmentsColor: [UIColor] = [
        .red,
        .pomergranate,
        .carrot,
        .emerald,
        .nephritis
    ]
    
    //MARK: - Init
    
    init(frame: CGRect, numberOfSegmenents: NumberOfSegments = .five, startAngle: CGFloat = -200 * .pi / 180, endAngle: CGFloat = 20 * .pi / 180, paddingBetweenSegments: CGFloat = .pi / 10) {
        self.numberOfSegments = numberOfSegmenents
        self.startAngle = startAngle
        self.endAnle = endAngle
        self.paddingBetweenSegments = paddingBetweenSegments
        self.progressBarLength = endAngle - startAngle
        self.segmentLength = (progressBarLength - (paddingBetweenSegments * CGFloat(numberOfSegments.rawValue - 1))) / CGFloat(numberOfSegments.rawValue)
        
        super .init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        createSegments()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSegmentsWithBounds()
    }
    
    //MARK: - Public method
    
    public func setProgress(_ overallProgress: CGFloat) {
        let segmentValue = 1 / CGFloat(numberOfSegments.rawValue)
        
        for i in 0..<numberOfSegments.rawValue {
            let segmentProgress: CGFloat = max(0, min(1, ((overallProgress - segmentValue * CGFloat(i)) / segmentValue)))
              
            segmentsProgressLayers[i].strokeEnd = segmentProgress
        }
    }
    
    //MARK: - Private methods
    
    private func createSegments() {
        for i in 0..<numberOfSegments.rawValue {
            
            let trackLayer = CAShapeLayer()
            trackLayer.fillColor = UIColor.clear.cgColor
            trackLayer.lineCap = CAShapeLayerLineCap.round
            trackLayer.strokeColor = segmentsColor[i].withAlphaComponent(0.2).cgColor
            segmentsTrackLayers.append(trackLayer)
            layer.addSublayer(trackLayer)
            
            let progressLayer = CAShapeLayer()
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.lineCap = CAShapeLayerLineCap.round
            progressLayer.strokeColor = segmentsColor[i].cgColor
            progressLayer.strokeEnd = 0
            segmentsProgressLayers.append(progressLayer)
            layer.addSublayer(progressLayer)
        }
    }
    
    private func updateSegmentsWithBounds() {
        let lineWidth = bounds.height / 9.5
        let radius = min(bounds.height, bounds.width) / 2 - lineWidth / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        for i in 0..<numberOfSegments.rawValue {
            let segmentStartAngle: CGFloat = startAngle + (segmentLength + paddingBetweenSegments) * CGFloat(i)
            
            let path = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: segmentStartAngle,
                endAngle: segmentStartAngle + segmentLength,
                clockwise: true
            )
            
            segmentsTrackLayers[i].path = path.cgPath
            segmentsTrackLayers[i].lineWidth = lineWidth
            segmentsProgressLayers[i].path = path.cgPath
            segmentsProgressLayers[i].lineWidth = lineWidth
        }
    }
}
