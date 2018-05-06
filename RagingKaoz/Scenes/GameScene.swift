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

    // Game state
    var currentCow = Cow()
    var currentPlayerActive = PlayerTurnCategory.Player1
    let playerTurnLabel = SKLabelNode(text: "")
    var gameIsActive = true
    
    // Setup
    var mapNode = SKTileMapNode()
    let gameCamera = GameCamera()
    var panRecognizer = UIPanGestureRecognizer()
    var pinchRecognizer = UIPinchGestureRecognizer()
    var maxScale: CGFloat = 0
    var scoreLabel1: SKLabelNode?
    var scoreLabel2: SKLabelNode?
    
    // Players
    var player1 = Cow()
    var player2 = Cow()
    var player1Score: Int = 0
    var player2Score: Int = 0
    
    override func didMove(to view: SKView) {
        setUpLevel()
        newGame()
        
        print("Gamescene Framesize - \(self.frame.size)")
        print("Mapnode Framesize - \(mapNode.frame.size)")
    }
    
    // --------- Game, map and camera setup ---------
    func setUpLevel(){
        if let mapNode = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = mapNode
            maxScale = mapNode.mapSize.height / frame.size.height
        }
        addMapBounds()
        addCamera()
        addGestureRecognizer()
        //setup2DOverlay()
        
        for child in mapNode.children {
            
            print("child pos \(child.position)")
            
        }
    
        self.physicsWorld.contactDelegate = self
    }
    
    func addMapBounds(){
        let floorNode = SKSpriteNode(color: UIColor.brown, size: CGSize(width: mapNode.frame.size.width, height: 32))
        floorNode.physicsBody = SKPhysicsBody(edgeLoopFrom: floorNode.frame)
        floorNode.physicsBody?.affectedByGravity = false
        floorNode.zPosition = 4
        addChild(floorNode)
        floorNode.position.x = mapNode.frame.size.width / 2
        floorNode.position.y = 0
        
        let mapBody = SKPhysicsBody(edgeLoopFrom: mapNode.frame)
        mapNode.physicsBody = mapBody
        mapNode.name = "map"
        playerTurnLabel.fontColor = UIColor.black
        playerTurnLabel.fontSize = 40
        
        
        self.addChild(playerTurnLabel)
    
        let centreWallNode = SKSpriteNode(color: .brown, size: CGSize(width: 50, height: self.size.height/3))
        centreWallNode.position = CGPoint(x: mapNode.frame.size.width/2, y: centreWallNode.size.height)
        centreWallNode.physicsBody = SKPhysicsBody(rectangleOf: centreWallNode.size)
        centreWallNode.physicsBody?.isDynamic = false
        self.addChild(centreWallNode)
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
    
    
    // --------- Init a new Game ---------
    func newGame(){
        gameIsActive = true
        makeCows()
        gameTurn(playerTurn: currentPlayerActive)
    }
    
    // --------- Creates the players ---------
    func makeCows(){
        if self.childNode(withName: "player1") != nil {
            player1.removeFromParent()
        }
        if self.childNode(withName: "player2") != nil {
            player2.removeFromParent()
        }
        player1 = Cow()
        player2 = Cow()
        addChild(player1)
        player1.position = CGPoint(x: mapNode.frame.size.width / 4, y: 150)
        player1.name = "player1"
        addChild(player2)
        player2.position = CGPoint(x: mapNode.frame.size.width / 1.5, y: 150)
        player2.name = "player2"
    }
    
    
    // --------- Logic for whos turs it is to play ---------
    func gameTurn(playerTurn : PlayerTurnCategory){
        switch playerTurn{
        case .Player1:
            currentCow = player1
        case .Player2:
            currentCow = player2
        }
        gameCamera.position = currentCow.position
        playerTurnLabel.text = "\(playerTurn)s Turn to move."
        playerTurnLabel.position = CGPoint(x: currentCow.position.x, y: currentCow.position.y + 70)
        currentCow.state = .Moving
    }
    
    func nextPlayer () {
        if currentPlayerActive == .Player1{
            currentPlayerActive = .Player2
            gameTurn(playerTurn: currentPlayerActive)
        } else if currentPlayerActive == .Player2 {
            currentPlayerActive = .Player1
            gameTurn(playerTurn: currentPlayerActive)
        }
    }
    
    
    // --------- Winning update ---------
    func showWinningScreen(){
        gameIsActive = false
        if player1.HP > player2.HP {
            print("Player1 won")
            player1Score += 1
        } else {
            print("Player2 won")
            player2Score += 1
        }
        playerTurnLabel.text = "Play Again"
        playerTurnLabel.position = gameCamera.position
        gameCamera.position = mapNode.position
        //Display score
    }
    

    // --------- Collision detection ---------
    func didBegin(_ contact: SKPhysicsContact) {
        var cowBody: SKPhysicsBody
        var bulletBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == BulletCategory {
            bulletBody = contact.bodyA
            if contact.bodyB.categoryBitMask == CowCategory {
                cowBody = contact.bodyB
                playerGotHit(player: cowBody.node as! Cow, bullet: bulletBody.node as! Bullet)
                //cow takes damage
            }
        }
        if contact.bodyB.categoryBitMask == BulletCategory {
            bulletBody = contact.bodyB
            if contact.bodyA.categoryBitMask == CowCategory {
                cowBody = contact.bodyA
                playerGotHit(player: cowBody.node as! Cow, bullet: bulletBody.node as! Bullet)
                //cow takes damage
            }
        }
        if !player1.isDead && !player2.isDead {
            if contact.bodyA.categoryBitMask == BulletCategory {
                let bullet = contact.bodyA.node as! Bullet
                bullet.removeFromParent()
                nextPlayer()
            }
            if contact.bodyB.categoryBitMask == BulletCategory {
                let bullet = contact.bodyB.node as! Bullet
                bullet.removeFromParent()
                nextPlayer()
            }
        }
    }
    
    func playerGotHit(player: Cow, bullet: Bullet){
        print("Cow : \(player) , Bullet : \(bullet)")
        
        player.HP -= 35
        bullet.removeFromParent()
        print("Player1 HP : \(player1.HP) , Player2 HP : \(player2.HP)")
        if player.isDead {
            showWinningScreen()
            return
        }
    }
    
    // Touches
    // Since I got basically no buttons the logic is handled with States
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: mapNode)
            if gameIsActive {
                //Moving State
                if currentCow.state == .Moving {
                    if playerTurnLabel.contains(location){
                        
                        currentCow.state = .Aiming
                        playerTurnLabel.text = "Place Your Aim"
                        playerTurnLabel.position = CGPoint(x: currentCow.position.x, y: currentCow.position.y + 70)
                        return
                    }
                    
                    if location.x > currentCow.position.x {
                        currentCow.move(dir: .right)
                    } else {
                        currentCow.move(dir: .left)
                    }
                    
                }
                //Aiming State
                if currentCow.state == .Aiming {
                    if playerTurnLabel.contains(location){
                        if currentCow.currentAim != nil {
                            currentCow.isCharging = true
                            
                        }
                    } else {
                        currentCow.aimPoint = location
                    }
                }
            } else {
                // Dead cow / restart game
                if playerTurnLabel.contains(location){
                    newGame()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentCow.isCharging {
            currentCow.fireGun()
            currentCow.state = .Waiting
        }
    }
    
}

extension GameScene {
    
    @objc func pan(sender: UIPanGestureRecognizer){
        guard let view = view else { return }
        let translation = sender.translation(in: view) * gameCamera.yScale
        gameCamera.position = CGPoint(x: gameCamera.position.x - translation.x, y: gameCamera.position.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
        
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
