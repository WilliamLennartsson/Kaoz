//
//  Config.swift
//  RagingKaoz
//
//  Created by will on 2018-04-13.
//  Copyright © 2018 will. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    static public func + (left: CGPoint, right: CGPoint) -> CGPoint{
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    static public func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static public func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
}
