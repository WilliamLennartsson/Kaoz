//
//  GameCamera.swift
//  RagingKaoz
//
//  Created by will on 2018-04-13.
//  Copyright © 2018 will. All rights reserved.
//

import SpriteKit

class GameCamera: SKCameraNode {

    func setConstraints(with scene: SKScene, and frame: CGRect, to node: SKNode?){
        let scaledSize = CGSize(width: scene.size.width * xScale, height: scene.size.height * yScale)
        let boardRect = frame
        let xInset = min(scaledSize.width / 2, boardRect.width / 2)
        let yInset = min(scaledSize.height / 2, boardRect.height / 2)
        
        let insetRect = boardRect.insetBy(dx: xInset, dy: yInset)
        
        let xRange = SKRange(lowerLimit: insetRect.minX, upperLimit: insetRect.maxX)
        let yRange = SKRange(lowerLimit: insetRect.minY, upperLimit: insetRect.maxY)
        let levelEdgeConstraints = SKConstraint.positionX(xRange, y: yRange)
        
        constraints = [levelEdgeConstraints]
    }
}
