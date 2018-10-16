//
//  Character.swift
//  SushiNeko
//
//  Created by Fodé Diop on 10/11/18.
//  Copyright © 2018 Fodé Diop. All rights reserved.
//
import SpriteKit

class Character: SKSpriteNode {
    // Character side
    let punch = SKAction(named: "Punch")!
    var side: Side = .left {
        didSet {
            if side == .left {
                xScale = 1
                position.x = 70
                print("Tapped left")
            } else  {
                xScale = -1
                position.x = 252
                print("Tapped right")
            }
            // Run the punch action
            print(punch)
            run(punch)
        }
    }
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
