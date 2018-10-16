//
//  SushiPiece.swift
//  SushiNeko
//
//  Created by Fodé Diop on 10/11/18.
//  Copyright © 2018 Fodé Diop. All rights reserved.
//

import SpriteKit

class SushiPiece: SKSpriteNode {
    var rightChopstick: SKSpriteNode!
    var leftChopstick: SKSpriteNode!
    
    // sushiType
    var side: Side = .none {
        didSet {
            switch side {
            case .left:
                leftChopstick.isHidden = false
            case .right:
                rightChopstick.isHidden = false
            case .none:
                leftChopstick.isHidden = true
                rightChopstick.isHidden = true
            }
        }
    }
    
    override init(texture: SKTexture? , color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func connectChopsticks() {
        rightChopstick = childNode(withName: "rightChopstick") as? SKSpriteNode
        leftChopstick = childNode(withName: "leftChopstick") as? SKSpriteNode
        
        /* Set the default side */
        side = .none
    }
    
    func flip(_ side: Side) {
        // Flip the suhsi out of the screen
        var actionName: String = ""
        if side == .left {
            actionName = "FlipRight"
        } else if side == .right {
            actionName = "FlipLeft"
        }
        
        // Load appropriate action
        let flip = SKAction(named: actionName)!
        // Create a node removal action
        let remove = SKAction.removeFromParent()
        // Build sequence, flip then remove the scene
        let sequence = SKAction.sequence([flip, remove])
        run(sequence)
    }
}


