//
//  StrokeAnimation.swift
//  RSComponents
//
//  Created by rajesh subramonian on 09/12/22.
//  Copyright © 2020 Hill side developer. All rights reserved.
//

import UIKit

class StrokeAnimation: CABasicAnimation {
    
    // 1
    enum StrokeType {
        case start
        case end
    }
    
    // 2
    override init() {
        super.init()
    }
    
    // 3
    init(type: StrokeType,
         beginTime: Double = 0.0,
         fromValue: CGFloat,
         toValue: CGFloat,
         duration: Double,
         repeatCount :Float,
         autoReverses:Bool) {
        
        super.init()
        
        self.keyPath = type == .start ? "strokeStart" : "strokeEnd"
        
        self.beginTime = beginTime
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.repeatCount = repeatCount
        //Continuous reversal
        self.autoreverses = autoReverses
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
