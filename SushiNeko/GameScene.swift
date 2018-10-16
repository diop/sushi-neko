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
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        addRandomPieces(total: 10)
        
        playButton.selectedHandler = {
            self.state = .ready
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .gameOver || state == .title { return }
        if state == .ready { state = .playing }
        
        health += 0.1
        score += 1
        
        let touch = touches.first!
        let location = touch.location(in: self)
        
        if location.x > size.width / 2 {
            character.side = .right
        } else {
            character.side = .left
        }
        
        if let firstPiece = sushiTower.first as SushiPiece? {
            if character.side == firstPiece.side {
                gameOver()
                return
            }
            sushiTower.removeFirst()
            firstPiece.flip(character.side)
            addRandomPieces(total: 1)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveTowerDown()
        
        if state != .playing { return }
        
        health -= 0.01
        if health < 0 {
            gameOver()
        }
    }
    
    func addTowerPiece(side: Side) {
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        let lastPiece = sushiTower.last
        
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 55
        
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        
        newPiece.side = side
        
        addChild(newPiece)
        
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
        
        let turnRed = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.50)
        
        sushiBasePiece.run(turnRed)
        for sushiPiece in sushiTower {
            sushiPiece.run(turnRed)
        }
        
        character.run(turnRed)
        
        playButton.selectedHandler = {
            let skView = self.view as SKView?
            
            guard let scene = GameScene(fileNamed: "GameScene") as GameScene? else {
                return
            }

            scene.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
        }
    }
}
