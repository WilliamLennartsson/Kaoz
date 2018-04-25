//
//  GameScene.swift
//  RagingKaoz
//
//  Created by will on 2018-04-13.
//  Copyright © 2018 will. All rights reserved.
//

import SpriteKit
import GameplayKit

enum PlayerTurnCategory {
    case Player1
    case Player2
}


class GameScene: SKScene, SKPhysicsContactDelegate {

    var currentCow = Cow()

    var currentPlayerActive = PlayerTurnCategory.Player1
    let playerTurnLabel = SKLabelNode(text: "")
    
    let moveBtnLeft = moveButton(size: CGSize(width: 100, height: 100))
    let moveBtnRight = moveButton(size: CGSize(width: 100, height: 100))
    
    var mapNode = SKTileMapNode()
    
    let gameCamera = GameCamera()
    var panRecognizer = UIPanGestureRecognizer()
    var pinchRecognizer = UIPinchGestureRecognizer()
    var maxScale: CGFloat = 0
    
    var player1 = Cow()
    var player2 = Cow()
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
//        let whichNode = (contact.bodyA.node != cow.player) ? contact.bodyA.node : contact.bodyB.node

        for bullet in player1.bullets {
            if contact.bodyA.categoryBitMask == bullet.physicsBody?.categoryBitMask
                && contact.bodyB.categoryBitMask == player1.physicsBody?.categoryBitMask {
                
                
                
            } else if contact.bodyB.categoryBitMask == bullet.physicsBody?.categoryBitMask
                && contact.bodyA.categoryBitMask == player1.physicsBody?.categoryBitMask {
                
            }
            
        }
        
        
//        if contact.bodyA.categoryBitMask == BulletCategory || contact.bodyB.categoryBitMask == BulletCategory {
//            print("MUUUU")
//        }
//        if contact.bodyA.contactTestBitMask == BulletCategory {
//            print("MUUUUX2")
//        }
//
//        if contact.bodyB.contactTestBitMask == BulletCategory {
//            print("MUUUUX3")
//        }
//
//    }
    }
    

    func playerGotHit(){
        
    }
        
        
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func didMove(to view: SKView) {
        setUpLevel()
        addGestureRecognizer()
        makeCows()
        
        
        print("Gamescene Framesize - \(self.frame.size)")
        print("Mapnode Framesize - \(mapNode.frame.size)")
        
        gameTurn(playerTurn: currentPlayerActive)
        
    }
    
    func gameTurn(playerTurn : PlayerTurnCategory){
        switch playerTurn{
        case .Player1:
            currentCow = player1
        case .Player2:
            currentCow = player2
        default:
            return
        }
        gameCamera.position = currentCow.position
        playerTurnLabel.text = "\(playerTurn)s Turn to move."
        playerTurnLabel.fontSize = 40
        playerTurnLabel.position = CGPoint(x: currentCow.position.x, y: currentCow.position.y + 70)
        currentCow.state = .Moving
        
    }
    
    func makeCows(){
        addChild(player1)
        player1.position = CGPoint(x: mapNode.frame.size.width / 4, y: 150)
        addChild(player2)
        player2.position = CGPoint(x: mapNode.frame.size.width / 1.5, y: 150)
        
    }
    
    func setUpLevel(){
        if let mapNode = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = mapNode
            maxScale = mapNode.mapSize.height / frame.size.height
        }
        addMapBounds()
        addCamera()
        self.physicsWorld.contactDelegate = self //where self is a current scene
        
    }
    
    func addMapBounds(){
        let floorNode = SKSpriteNode(color: UIColor.brown, size: CGSize(width: mapNode.frame.size.width, height: 32))
        floorNode.physicsBody = SKPhysicsBody(edgeLoopFrom: floorNode.frame)
        floorNode.physicsBody?.affectedByGravity = false
        floorNode.zPosition = 4
        addChild(floorNode)
        floorNode.position.x = mapNode.frame.size.width / 2
        floorNode.position.y = floorNode.size.height
        
        let aoda = SKPhysicsBody(edgeLoopFrom: mapNode.frame)
        mapNode.physicsBody = aoda
        
        self.addChild(moveBtnLeft)
        self.addChild(moveBtnRight)
        //moveBtnLeft.position = CGPoint(x: gameCamera.position.x - gameCamera., y: <#T##CGFloat#>)
        moveBtnRight.position = CGPoint(x:gameCamera.position.x + moveBtnLeft.size.width , y: gameCamera.position.y)
        moveBtnLeft.color = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
        
        let centreWallNode = SKSpriteNode(color: .brown, size: CGSize(width: 50, height: self.size.height/3))
        centreWallNode.position = CGPoint(x: mapNode.frame.size.width/2, y: centreWallNode.size.height)
        self.addChild(centreWallNode)
        
        self.addChild(playerTurnLabel)
        
    }
    
    func addCamera(){
        guard let view = view else { return }
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        camera = gameCamera
        gameCamera.setConstraints(with: self, and: mapNode.frame, to: nil)
    }
    
    func addGestureRecognizer(){
        guard let view = view else { return }
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panRecognizer)
        
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        view.addGestureRecognizer(pinchRecognizer)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: mapNode)
            
            if currentCow.state == .Moving {
                if playerTurnLabel.contains(location){
                    currentCow.state = .Aiming
                    playerTurnLabel.text = "Place Your Aim"
                    playerTurnLabel.position = CGPoint(x: currentCow.position.x, y: currentCow.position.y + 70)
                    return
                }
                
                if location.x > player1.position.x {
                    currentCow.move(dir: .right)
                } else {
                    currentCow.move(dir: .left)
                }
            }
            
            if currentCow.state == .Aiming {
                
                currentCow.aim(position: location)
                print(currentCow.aimPoint)
                
            }
            
            
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}


extension GameScene {
    
    @objc func pan(sender: UIPanGestureRecognizer){
        guard let view = view else { return }
        let translation = sender.translation(in: view) * gameCamera.yScale
        gameCamera.position = CGPoint(x: gameCamera.position.x - translation.x, y: gameCamera.position.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
        
        
        
        //print("View size \(view.frame.size.width) , \(view.frame.size.height)")
       // moveBtnRight.position = CGPoint(x:gameCamera.position.x , y: gameCamera.position.y)
        //moveBtnLeft.position = CGPoint(x:gameCamera.position.x , y: gameCamera.position.y)
        
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer){
        guard let view = view else { return }
        if sender.numberOfTouches == 2{
            
            let locationInView = sender.location(in: view)
            let location = convertPoint(fromView: locationInView)
            
            if sender.state == .changed {
                let convertedScale = 1/sender.scale
                let newScale = gameCamera.yScale*convertedScale
                if newScale < maxScale && newScale > 0.5 {
                    gameCamera.setScale(newScale)
                }
                
                let locationAfterScale = convertPoint(fromView: locationInView)
                let locationDelta = location - locationAfterScale
                let newPos = gameCamera.position + locationDelta
                gameCamera.position = newPos
                sender.scale = 1.0
                gameCamera.setConstraints(with: self, and: mapNode.frame, to: nil)
            }
        }
    }
}






