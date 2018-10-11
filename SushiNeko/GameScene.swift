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
    var sushiTower: [SushiPiece] = []
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        sushiBasePiece = childNode(withName: "sushiBasePiece") as? SushiPiece
        character = childNode(withName: "character") as? Character
        sushiBasePiece.connectChopsticks()
        
        // Manually stack the start of the tower
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        
    }
    
    func addTowerPiece(side: Side) {
        // Add a new Sushi Piece
        
        // Copy original sushi piece
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        // Access las piece
        let lastPiece = sushiTower.last
        
        // Add on top of last piece
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 55
        
        // Increment Z to make sure it's on top of last piece
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        
        // Set Side
        newPiece.side = side
        
        // Add sushi to scene
        addChild(newPiece)
        
        // Add sushi piece to the sushi tower
        sushiTower.append(newPiece)
    }
    
}
