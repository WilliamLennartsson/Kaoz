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
    var maxLives = 3
    var livesLeft: [SKSpriteNode] = []
    let maxHP = 100
    var HP: Int = 100 {
        didSet {
            livesLeft[livesLeft.count - 1].removeFromParent()
            livesLeft.removeLast()
            if livesLeft.count <= 0 {
                isDead = true
            }
        }
    }
    
    let cowSpeed: CGFloat = 8
    var isAiming = false
    var chargeForce: CGFloat = 4.5
    
    var isCharging = false {
        didSet{
            if isCharging {
                let charge = SKAction.run {
                    self.chargeForce += 0.17
                    print(self.chargeForce)
                    self.childNode(withName: "ChargeMeter")?.childNode(withName: "Progress")?.position.y -= 5
                    if self.chargeForce > 11 {
                        self.fireGun()
                    }
                }
                
                let wait = SKAction.wait(forDuration: 0.1)
                let sequence = SKAction.sequence([charge, wait])
                self.run(SKAction.repeatForever(sequence), withKey: "Charge")
                chargeMeter()
            } else {
                if self.action(forKey: "Charge") != nil {
                    self.removeAction(forKey: "Charge")
                    chargeForce = 3
                    if let meter = self.childNode(withName: "ChargeMeter") {
                        meter.removeFromParent()
                    }
                }
            }
        }
    }
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
                self.removeFromParent()
            }
        }
    }
    
    let cowSize = CGSize(width: 64, height: 64)
    init() {
        
        let texture = SKTexture(imageNamed: "player")
        super.init(texture: texture, color: UIColor.clear, size:cowSize )
        position = CGPoint(x: super.frame.size.width/2, y: super.frame.size.height/2)
        physicsBody = SKPhysicsBody(circleOfRadius: cowSize.width/2)
        physicsBody?.affectedByGravity = true
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsBody?.categoryBitMask = CowCategory
        physicsBody?.contactTestBitMask = BulletCategory
        physicsBody?.collisionBitMask = BulletCategory
        createHealthBars()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fireGun(){
        if let aim = aimPoint {
            
            let bulletSpeed: CGFloat = 150
            var deltaX = (aim.x - position.x)
            var deltaY = (aim.y - position.y)
            let mag = sqrt(deltaX * deltaX + deltaY * deltaY)
            deltaX /= mag
            deltaY /= mag
            
            let dx: CGFloat = deltaX * bulletSpeed * chargeForce
            let dy: CGFloat = deltaY * bulletSpeed * chargeForce
            let dir: CGVector = CGVector(dx: dx, dy: dy)
            
            let bullet = Bullet()

            super.addChild(bullet)
            bullet.physicsBody?.applyImpulse(dir)
            currentAim?.removeFromParent()
            currentAim = nil
            self.aimPoint = nil
            isCharging = false
            print("shot")
        }
    }
    
    func aim(position: CGPoint){
        currentAim?.removeFromParent()
        currentAim = SKSpriteNode(imageNamed: "aimBro2")
        currentAim!.size = CGSize(width: 100, height: 100)
        isAiming = true
    
        currentAim!.position = aimPoint!
        currentAim!.anchorPoint = CGPoint(x: 1, y: 1)
        parent?.childNode(withName: "map")?.addChild(currentAim!)
    }
    
    func createHealthBars (){
        var xOffset: CGFloat = 0
        for _ in 1...maxLives {
            let life = SKSpriteNode(imageNamed: "heart")
            life.size = CGSize(width: cowSize.width/3, height: cowSize.height/3)
            let xPos: CGFloat = (-cowSize.width/2) + xOffset
            life.position = CGPoint(x: xPos, y: position.y + cowSize.height/2)
            xOffset += life.size.width
            self.addChild(life)
            livesLeft.append(life)
        }
    }
    
    func chargeMeter(){
        let progress: SKSpriteNode = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 20, height: 200))
        progress.position = CGPoint(x: 0, y: self.position.y + 100)
        progress.name = "Progress"
        let theMask: SKSpriteNode = SKSpriteNode(color: UIColor.green, size: CGSize(width: 50, height: 200))
        theMask.position = progress.position
        let cropNode:SKCropNode = SKCropNode()
        cropNode.name = "ChargeMeter"
        cropNode.addChild(progress)
        cropNode.maskNode = theMask
        self.addChild(cropNode)
    }
    
    func move(dir: Direction){
        switch dir {
        case .left:
            print("moved left")
            
            physicsBody?.applyForce(CGVector(dx: -350, dy: 0))
        case .right:
            print("moved right")
            physicsBody?.applyForce(CGVector(dx: 350, dy: 0))
        }
    }
}
