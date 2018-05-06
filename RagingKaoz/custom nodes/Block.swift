//
//  Block.swift
//  RagingKaoz
//
//  Created by will on 2018-05-04.
//  Copyright © 2018 will. All rights reserved.
//
import SpriteKit

class Block: SKSpriteNode {
    
    init(){
        super.init(texture: nil, color: .clear, size: CGSize.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPhysicsBody(){
        
    }
    
}
