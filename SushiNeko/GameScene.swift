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
    var sushiBasePiece : SushiPiece!
    var character : Character!
    var sushiTower: [SushiPiece] = []
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        sushiBasePiece = childNode(withName: "sushiBasePiece") as? SushiPiece
        character = childNode(withName: "character") as? Character
        sushiBasePiece.connectChopsticks()
        
        // Manually stack the start of the tower
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        
        // Randomize tower to 10 outside of screen
        addRandomPieces(total: 10)
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
    
    func addRandomPieces(total: Int) {
        // Add random sushi pieces to the sushi tower
        
        for _ in 1...total {
            // Need to access last piece property
            let lastPiece = sushiTower.last!
            
            // Impossible tower check
            if lastPiece.side != .none {
                addTowerPiece(side: .none)
            } else {
                let rand = arc4random_uniform(100)
                if rand < 45 {
                    addTowerPiece(side: .left)
                } else if rand < 90 {
                    addTowerPiece(side: .right)
                } else {
                    addTowerPiece(side: .none)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        print(character)
        if location.x > size.width / 2 {
            character.side = .right
        } else {
            character.side = .left
        }
        
        // Remove from sushi tower array
        if let firstPiece = sushiTower.first as SushiPiece? {
            sushiTower.removeFirst()
            firstPiece.removeFromParent()
            addRandomPieces(total: 1)
        }
    }
}
