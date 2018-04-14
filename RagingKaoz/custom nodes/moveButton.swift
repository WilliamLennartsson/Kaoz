//
//  moveButton.swift
//  RagingKaoz
//
//  Created by will on 2018-04-13.
//  Copyright © 2018 will. All rights reserved.
//

import SpriteKit

class moveButton: SKSpriteNode {
    
    let buttonSize : CGSize
    var leftButton: SKSpriteNode
    var rightButton: SKSpriteNode
    
    init(size: CGSize) {
        buttonSize = size
        
        leftButton = SKSpriteNode(color: UIColor.red, size: CGSize(width: buttonSize.width/2, height: buttonSize.height))
        
        
        rightButton = SKSpriteNode(color: UIColor.green, size: CGSize(width: buttonSize.width/2, height: buttonSize.height))
        
        super.init(texture: nil, color: UIColor.red, size: size)
        
        addChild(leftButton)
        addChild(rightButton)
        leftButton.position = CGPoint(x: 0, y: 0)
        rightButton.position = CGPoint(x: leftButton.size.width, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
