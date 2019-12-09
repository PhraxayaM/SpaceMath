//
//  GameScene.swift
//  SpaceMath
//
//  Created by MattHew Phraxayavong on 12/3/19.
//  Copyright © 2019 Matthew Phraxayavong. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    
    var mainShip: Ship = Ship()
    var debris: SKNode!
    var debrisTexture = ["wingGreen_6", "meteorBrown_big3"]
    var spawnedDebris: Int = 0
    var maxDebris: Int = 4
    var scoreLabel: SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    var spawnerFixedDelta: Double = 1
    var scrollSpeed: CGFloat = 25
    var spawnTimer: CFTimeInterval = 0
    var problemLabel = SKLabelNode(fontNamed: "Optima-Bold")
    var arg1 : Int?
    var arg2 : Int?
    var ans1 = 0
    var ans2 = 0
//    var newDebris: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        startGame()
        createMathProblem()
        createScoreLabel()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        updateDebris()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            let move = SKAction.move(to: touchLocation, duration: 1)
            mainShip.run(move)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           let touch = touches.first
           
           if let location = touch?.location(in: self) {
               let nodesArray = self.nodes(at: location)
               
               if nodesArray.first?.name == "play_button" {
                   let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                   let gameScene = GameScene(size: self.size)
                   self.view?.presentScene(gameScene, transition: transition)
               }
           }
       }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        mainShip.fireBeam(scene: self)
    }
    
    func startGame() {
        initNodes()
        updateDebris()
        
    }
    
    func initNodes() {
        if let ship: Ship = self.childNode(withName: "shipNode") as? Ship {
            self.mainShip = ship
            self.mainShip.beam = self.childNode(withName: "beam")!
            self.mainShip.initBody()
            
        }
        
        if let debris = self.childNode(withName: "//debri") as? SKSpriteNode  {
            
            self.debris = debris
            self.debris.physicsBody?.categoryBitMask = PhysicsCategory.None
            self.debris.physicsBody?.contactTestBitMask = PhysicsCategory.None
            self.debris.physicsBody?.collisionBitMask = PhysicsCategory.None
            
        }
    }
    
    func createScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        addChild(scoreLabel)
    }
    func createMathProblem() {
    // generate 2 random integers
    arg1 = Int.random(in: 5...10)
    arg2 = Int.random(in: 5...10)
    
    if let arg1 = arg1{
        if let arg2 = arg2 {
            // Display the problem. Integer1 + Integer2
            problemLabel.text = ("\(arg1) + \(arg2)")
            
        }
    }
    // set property labels
        if let view = self.view{
            problemLabel.fontSize = 100
            problemLabel.fontColor = .white
            problemLabel.position.x = view.bounds.width/2 - 150
            problemLabel.position.y = (view.bounds.height/2)
            problemLabel.zPosition = 2
            addChild(problemLabel)
        }
//        if problemLabel.parent == nil {
//            addChild(problemLabel)
//        }
    }
    
    func updateDebris() {
        spawnTimer += fixedDelta
        
        if spawnTimer >= spawnerFixedDelta {
            if debris == nil {
                return
            }
            if let newDebris = debris.copy() as? SKSpriteNode {
            newDebris.physicsBody?.affectedByGravity = true
            newDebris.physicsBody?.isDynamic = true
            newDebris.physicsBody?.allowsRotation = true
            newDebris.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.random(in: -1...1), duration: 1.0)))
            newDebris.physicsBody?.categoryBitMask = PhysicsCategory.debris
            newDebris.physicsBody?.contactTestBitMask = PhysicsCategory.beamNode | PhysicsCategory.ship
                newDebris.physicsBody?.collisionBitMask = PhysicsCategory.ship | PhysicsCategory.beamNode
            newDebris.name = "debris"
            // NOTE: gets random element in array
            newDebris.texture =  SKTexture(imageNamed: debrisTexture.randomElement()!)
            
            let randomPositionX  = CGFloat.random(in: 0..<size.width)
            let positionX = CGFloat(randomPositionX)
            newDebris.position.x = positionX
            newDebris.position.y = (view?.bounds.height)!
            
    
            self.addChild(newDebris)
//            let randomPosition = CGPoint(x: CGFloat.random(in: 15..<((scene?.size.width)! - 15)), y: debris.position.y)
//            let randomPosition
            newDebris.zPosition = 100
//            newDebris.position = (self.scene?.convert(randomPosition, to: self))!
            
            spawnedDebris += 1
            
            spawnTimer = 0
            }
        }
    }
    func didBegin(_ contact: SKPhysicsContact)  {
        print("BEAM BEAM")
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask  {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if contact.bodyA.categoryBitMask == PhysicsCategory.debris {
            print("touched")
        } else {
            print("touched")
        }

        checkBeamCollision(contact)
    }
    
    func checkBeamCollision(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        if bodyA.categoryBitMask == PhysicsCategory.beamNode {
            bodyA.node?.removeFromParent()
        } else if bodyB.categoryBitMask == PhysicsCategory.beamNode {
            bodyB.node?.removeFromParent()
        }
        
    }
    
    
}
