//
//  GameScene.swift
//  SushiNeko
//
//  Created by Fodé Diop on 10/4/18.
//  Copyright © 2018 Fodé Diop. All rights reserved.
//

import SpriteKit

enum Side {
    case left, right, none
}

class GameScene: SKScene {
    /* Game objects */
    var sushiBasePiece: SushiPiece!
    var character: Character!
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        sushiBasePiece = childNode(withName: "sushiBasePiece") as? SushiPiece
        character = childNode(withName: "character") as? Character
        sushiBasePiece.connectChopsticks()
        
    }
    
}
