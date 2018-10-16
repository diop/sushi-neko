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

enum GameState {
    case title, ready, playing, gameOver
}

class GameScene: SKScene {
    /* Game objects */
    var sushiBasePiece : SushiPiece!
    var character : Character!
    var sushiTower: [SushiPiece] = []
    var state: GameState = .title
    var playButton: MSButtonNode!
    var healthBar: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var health: CGFloat = 1.0 {
        didSet {
            // Scale health bar between 0.0 -> 1.0 eg 0 -> 100%
            // Cap Helth
            if health > 0 { health = 1.0 }
            healthBar.xScale = health
        }
    }
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        sushiBasePiece = childNode(withName: "sushiBasePiece") as? SushiPiece
        character = childNode(withName: "character") as? Character
        playButton = childNode(withName: "playButton") as? MSButtonNode
        healthBar = childNode(withName: "healthBar") as? SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        sushiBasePiece.connectChopsticks()
        
        // Manually stack the start of the tower
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        
        // Randomize tower to 10 outside of screen
        addRandomPieces(total: 10)
        
        // Setup play button selection handler
        self.state = .ready
        
        playButton.selectedHandler = {
            // Start game
            self.state = .ready
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if state != .playing { return }
        
        // Decrease health
        health -= 0.01
        // Has the player ran out of health?
        if health < 0 {
            gameOver()
        }
        
        moveTowerDown()
        
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
            if character.side == firstPiece.side {
                gameOver()
                return
            }
            sushiTower.removeFirst()
            firstPiece.flip(character.side)
            addRandomPieces(total: 1)
        }
        
        // Game not ready
        if state == .gameOver || state == .title { return }
        // Game begins in first touch
        if state == .ready { state = .playing }
        
        // Increment Health
        health += 0.1
        score += 1
    }
    
    func moveTowerDown() {
        var n: CGFloat = 0
        for piece in sushiTower {
            let y = (n * 55) + 215
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
    
    func gameOver() {
        state = .gameOver
        
        // Create turned SKAction
        let turnRed = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.50)
        
        // Turn all the sushi pieces red
        sushiBasePiece.run(turnRed)
        for sushiPiece in sushiTower {
            sushiPiece.run(turnRed)
        }
        
        character.run(turnRed)
        
        // Change the button selection handler
        playButton.selectedHandler = {
            // Grad reference to the SpriteKit view
            let skView = self.view as SKView?
            
            // Load game scene
            guard let scene = GameScene(fileNamed: "GameScene") as GameScene? else {
                return
            }
            
            // Ensure correct aspect mode
            scene.scaleMode = .aspectFill
            
            // Restart GameScene
            skView?.presentScene(scene)
        }
    }
}
