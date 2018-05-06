//
//  Bullet.swift
//  RagingKaoz
//
//  Created by will on 2018-04-18.
//  Copyright © 2018 will. All rights reserved.
//

import SpriteKit

class Bullet: SKSpriteNode {

    private let boxSize = CGSize(width: 20, height: 20)
    override var speed: CGFloat{
        didSet{
            if speed == 0 {
                self.removeFromParent()
            }
        }
    }
    
    init() {
        super.init(texture: nil, color: UIColor.black, size: boxSize)
        position = CGPoint(x: position.x + 32, y: position.y + 65)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.affectedByGravity = true
        physicsBody?.mass = 1
        physicsBody?.categoryBitMask = BulletCategory
        physicsBody?.contactTestBitMask = CowCategory
        physicsBody?.collisionBitMask = CowCategory | BulletCategory | GroundCategory
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
