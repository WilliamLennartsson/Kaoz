//
//  Cow.swift
//  RagingKaoz
//
//  Created by will on 2018-04-13.
//  Copyright © 2018 will. All rights reserved.
//

import SpriteKit

struct Bazooka {
    let damage = 10
    let bulletSpeed = 2
}

enum Direction {
    case left
    case right
}

class Cow: SKSpriteNode {
    
    var HP: Int = 150
    let cowSpeed: CGFloat = 8
    
    let weapon = Bazooka()
    var isDead: Bool = false {
        didSet{
            if isDead{
                
            }
        }
    }
    
    let cowSize = CGSize(width: 64, height: 64)
    init() {
        super.init(texture: nil, color: UIColor.red, size:cowSize )
        position = CGPoint(x: super.frame.size.width/2, y: super.frame.size.height/2)
        physicsBody = SKPhysicsBody(circleOfRadius: cowSize.width/2)
        physicsBody?.affectedByGravity = true
        physicsBody?.isDynamic = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fireGun(dir: CGVector){
        
        var bullet = SKSpriteNode(color: UIColor.black, size: CGSize(width: 20, height: 20))
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.affectedByGravity = true
        bullet.position = CGPoint(x: position.x, y: position.y)
        bullet.physicsBody?.mass = 1
        super.addChild(bullet)
        
        bullet.physicsBody?.applyImpulse(dir)
        
        print("shot")
    }
    
    func move(dir: Direction){
        switch dir {
        case .left:
            print("moved left")
            physicsBody?.applyForce(CGVector(dx: -200, dy: 0))
        case .right:
            print("moved right")
            physicsBody?.applyForce(CGVector(dx: 200, dy: 0))
        }
    }
}
