//
//  CircularProgressBar.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 15/06/2022.
//

import UIKit

enum CircularProgressBarType {
    case round
    case gradient
}

class CircularProgressBar: UIView {
    
    var type: CircularProgressBarType
    var progress: Float
    var color: CGColor?
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    init(frame: CGRect, type: CircularProgressBarType, progress: Float, color: CGColor?) {
        
        self.type = type
        self.progress = progress
        self.shapeLayer.strokeColor = color
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        addProgressBar()
    }
    
    func addProgressBar() {
        
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
        trackLayer.lineWidth = 9
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        //BarLayer
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color ?? UIColor.clouds.cgColor
        shapeLayer.lineWidth = 9
        shapeLayer.strokeEnd = CGFloat(progress)
        shapeLayer.lineCap = CAShapeLayerLineCap.round
    }
    
    private func addGradient() {
        let gradient = CAGradientLayer()
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
