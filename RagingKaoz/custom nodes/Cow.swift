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

enum PlayerState {
    case Moving
    case Aiming
    case AimLocked
    case Waiting
}

enum Direction {
    case left
    case right
}

class Cow: SKSpriteNode {
    
    
    var state : PlayerState = .Waiting
    var bullets: [Bullet] = []
    var magasine: [Bullet] = []
    var HP: Int = 150
    let cowSpeed: CGFloat = 8
    
    var isAiming = false
    var currentAim: SKSpriteNode?
    var aimPoint: CGPoint? {
        didSet{
            if aimPoint != nil {
                aim(position: aimPoint!)
            } else {
                isAiming = false
            }
        }
    }
    
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
        physicsBody?.allowsRotation = false
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsBody?.categoryBitMask = CowCategory
        physicsBody?.contactTestBitMask = BulletCategory //Contact will be detected when GreenBall make a contact with RedBar or a Wall (assuming that redBar's masks are already properly set)
        physicsBody?.collisionBitMask = BulletCategory

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fireGun(){
        //Todo: Force charger
        if let aim = aimPoint {
            
            let bulletSpeed: CGFloat = 150
            let chargeForce: CGFloat = 5
            var deltaX = (aim.x - position.x)
            var deltaY = (aim.y - position.y)
            let mag = sqrt(deltaX * deltaX + deltaY * deltaY)
            deltaX /= mag
            deltaY /= mag
            
            let dx: CGFloat = deltaX * bulletSpeed * chargeForce
            let dy: CGFloat = deltaY * bulletSpeed * chargeForce
            let dir: CGVector = CGVector(dx: dx, dy: dy)
            
            //var bullet = SKSpriteNode(color: UIColor.black, size: CGSize(width: 20, height: 20))
            let bullet = Bullet()
            
            
//            bullet.position = CGPoint(x: position.x, y: position.y)
//            bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
//            bullet.physicsBody?.affectedByGravity = true
//            bullet.physicsBody?.mass = 1
//            
            //bullet.physicsBody?.collisionBitMask = Colli
            super.addChild(bullet)
            bullet.physicsBody?.applyImpulse(dir)
            currentAim?.removeFromParent()
            currentAim = nil
            self.aimPoint = nil
            print("shot")
            bullets.append(bullet)
        }
    }
    
    
    func aim(position: CGPoint){
        currentAim?.removeFromParent()
        

        currentAim = SKSpriteNode(imageNamed: "aimBro2")
        currentAim!.size = CGSize(width: 100, height: 100)
        isAiming = true
        currentAim!.position = position
        
//        let anchor = CGPoint(x: (currentAim?.position.x)! - ((currentAim?.size.width)!/2), y: (currentAim?.position.y)! - ((currentAim?.size.height)!/2))
        currentAim!.anchorPoint = CGPoint(x: 1, y: 1)
        print("\(currentAim?.position)")
        
        super.addChild(currentAim!)
        
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
