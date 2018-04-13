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
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(dir: Direction){
        switch dir {
        case .left:
            print("moved left")
        case .right:
            print("moved right")
        }
    }
}
