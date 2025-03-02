//
//  CustomActivityView.swift
//  Test
//
//  Created by Дмитрий Мартьянов on 02.03.2025.
//

import UIKit

final class CustomActivityView: UIView {
    
    private lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(shapeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = min(bounds.width / 2.0, bounds.height / 2.0)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        let path = UIBezierPath(
            arcCenter: CGPoint(x: rect.midX, y: rect.midY),
            radius: 10.0,
            startAngle: Self.startAngle,
            endAngle: Self.endAngle,
            clockwise: true
        )
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5.0
        shapeLayer.lineCap = .round
        shapeLayer.bounds = path.bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
    }
    func startAnimating(_ speed: CGFloat = 2.0) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2.0 * .pi
        rotationAnimation.duration = speed
        rotationAnimation.repeatCount = .infinity
        
        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.beginTime = speed / 3.0
        headAnimation.fromValue = 0
        headAnimation.toValue = 1
        headAnimation.duration = speed / 1.5
        headAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        tailAnimation.duration = speed / 1.5
        tailAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = speed
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.animations = [headAnimation, tailAnimation, rotationAnimation]
        shapeLayer.add(groupAnimation, forKey: animationKey)
    }
    
    func stopAnimating() {
        shapeLayer.removeAnimation(forKey: animationKey)
    }
    
    // MARK: - Constants
    private static let startAngle: CGFloat = 0.0
    private static let endAngle: CGFloat = 2.0 * .pi
    
    private let animationKey: String = "animationGroup"
}
