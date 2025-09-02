//
//  ProgressView.swift
//  RSComponents
//
//  Created by rajesh subramonian on 07/12/22.
//  Copyright © 2020 Hill side developer. All rights reserved.
//

import UIKit


private extension CGFloat {
    static var initialAngle: CGFloat = -(.pi / 2)
    
    static func endAngle(progress: CGFloat) -> CGFloat {
        .pi * 2 * progress + .initialAngle
    }
}

class CircularProgressView: UIView {
    private var radius: CGFloat { (bounds.height - lineWidth) / 2 }
    private let baseLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let progress: CGFloat
    private var lineWidth: CGFloat = 4.0
    let circularAnimation = "circularAnimation"
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public init(progress: CGFloat, baseColor: UIColor, progressColor: UIColor,width:CGFloat = 4.0) {
        self.progress = progress
        self.baseLayer.removeFromSuperlayer()
        self.progressLayer.removeFromSuperlayer()
        lineWidth = width
        for layer in [baseLayer, progressLayer] {
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = lineWidth
            layer.lineCap = .square
        }
        baseLayer.strokeColor = baseColor.cgColor
        baseLayer.strokeEnd = 1.0
        baseLayer.allowsEdgeAntialiasing = true
        baseLayer.edgeAntialiasingMask = [.layerLeftEdge, .layerRightEdge, .layerBottomEdge, .layerTopEdge]

        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.strokeEnd = 0.0
        progressLayer.allowsEdgeAntialiasing = true
        progressLayer.edgeAntialiasingMask = [.layerLeftEdge, .layerRightEdge, .layerBottomEdge, .layerTopEdge]

        super.init(frame: .zero)
        
        layer.addSublayer(baseLayer)
        layer.addSublayer(progressLayer)
    }
    
    public func animateCircle(duration: TimeInterval, delay: TimeInterval) {
        progressLayer.removeAnimation(forKey: circularAnimation)
        progressLayer.strokeEnd = 0
        animateStroke()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        baseLayer.frame = bounds
        progressLayer.frame = bounds
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let basePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: .initialAngle, endAngle: .endAngle(progress: 1), clockwise: true)
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: .initialAngle, endAngle: .endAngle(progress: progress), clockwise: true)
        baseLayer.path = basePath.cgPath
        progressLayer.path = progressPath.cgPath
    }
    func stopAnimation() {
        self.progressLayer.removeAnimation(forKey: circularAnimation)
        self.baseLayer.removeFromSuperlayer()
        self.progressLayer.removeFromSuperlayer()
        self.progressLayer.path = nil
        self.layer.removeAllAnimations()
    }
    
}

private extension CircularProgressView {
    
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.beginTime = 1.2
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.infinity
        progressLayer.add(rotateAnimation, forKey: nil)
    }
    
    //Adding a simple grow & auto-shrink logic to suit the endless loop req. of the stroke animation.
    func incrementStroke(){
        let strokeAnimation = StrokeAnimation(
            type: .end,
            fromValue: 0.1,
            toValue: 0.5,
            duration: 1.2,
            repeatCount: .infinity,
            autoReverses: true
        )
        progressLayer.add(strokeAnimation, forKey: circularAnimation)
    }

    func animateStroke() {
        progressLayer.strokeEnd = 0.1
        self.rotate360Degrees(duration: 1.2)
        incrementStroke()
    }
}
