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
    
    init(size: CGSize) {
        buttonSize = size
        super.init(texture: nil, color: UIColor.red, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
