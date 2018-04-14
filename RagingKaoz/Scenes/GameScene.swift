//
//  GameScene.swift
//  RagingKaoz
//
//  Created by will on 2018-04-13.
//  Copyright © 2018 will. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var mapNode = SKTileMapNode()
    
    let gameCamera = GameCamera()
    var panRecognizer = UIPanGestureRecognizer()
    var pinchRecognizer = UIPinchGestureRecognizer()
    var maxScale: CGFloat = 0
    let moveBtn = moveButton(size: CGSize(width: 150, height: 150))
    
    
    var cow = Cow()
    var enemyCow = Cow()
    
    
    override func didMove(to view: SKView) {
        setUpLevel()
        addGestureRecognizer()
        makeCows()
        
    }
    
    func makeCows(){
        addChild(cow)
        cow.position = CGPoint(x: 70, y: 1000)
        addChild(enemyCow)
        enemyCow.position = CGPoint(x: 500, y: 1000)
        
    }
    
    func setUpLevel(){
        if let mapNode = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = mapNode
            maxScale = mapNode.mapSize.height / frame.size.height
        }
        addMapBounds()
        addCamera()
        
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
        addChild(moveBtn)
        moveBtn.position = CGPoint(x: mapNode.frame.size.width/2, y: mapNode.frame.size.height/2)
        
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
            let location = touch.location(in: self)
            
            
            print("\(location) location . \(moveBtn.position) button pos")
            if frame.contains(location) {
                let bulletSpeed: CGFloat = 150
                var deltaX = (location.x - cow.position.x)
                var deltaY = (location.y - cow.position.y)
                let chargeForce: CGFloat = 5
                let mag = sqrt(deltaX * deltaX + deltaY * deltaY)
                deltaX /= mag
                deltaY /= mag
                
                let dx: CGFloat = deltaX * bulletSpeed * chargeForce
                let dy: CGFloat = deltaY * bulletSpeed * chargeForce
                let dir: CGVector = CGVector(dx: dx, dy: dy)
                
                cow.fireGun(dir: dir)
                
                
                if moveBtn.leftButton.contains(location){
                    cow.move(dir: .left)
                }
                if moveBtn.rightButton.contains(location){
                    cow.move(dir: .right)
                }
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






