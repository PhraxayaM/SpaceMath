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
    var debrisClass: Debris = Debris()
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
    var problemLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    var arg1 : Int?
    var arg2 : Int?
    var ans1 = 0
    var ans2 = 0
        
    
    override func didMove(to view: SKView) {
        startGame()
        let create = SKAction.run {
            self.createDebris()
        }
        let spawnTime = SKAction.wait(forDuration: 0.8)
        let debrisMakerSeq = SKAction.sequence([create, spawnTime])
        
        let debrisRepeat = SKAction.repeatForever(debrisMakerSeq)
        self.run(debrisRepeat)
        
        createMathProblem()
        createScoreLabel()
        self.physicsWorld.contactDelegate = self
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //        updateDebris()
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
        createDebris()
        //        updateDebris()
        
    }
    
    func initNodes() {
        if let ship: Ship = self.childNode(withName: "shipNode") as? Ship {
            self.mainShip = ship
            self.mainShip.beam = self.childNode(withName: "beam")!
            //            self.mainShip.physicsBody?.allowsRotation = false
            self.mainShip.initBody()
            
        }
        
    }
    
    // Creates debris function using the Debris class
    
    func createDebris() {
        let debris = Debris(number: 99)
        debris.physicsBody = SKPhysicsBody(circleOfRadius: debris.size.width)
        debris.physicsBody?.affectedByGravity = false
        addChild(debris)
        debris.position = CGPoint(x: CGFloat.random(in: 0..<size.width), y: (view?.bounds.height)!)
        debris.moveDown()
    }
    
    // Creates label function for the score
    
    func createScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position.x = ((view?.bounds.width)!/2 - 450)
        scoreLabel.position.y = ((view?.bounds.height)!/2 + 300)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        addChild(scoreLabel)
    }
    
    // Creates math problem
    
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
            if problemLabel.parent == nil {
                addChild(problemLabel)
            }
        }
        
    }
    
    // Function to call when updating score
    
    func scoreUpdate(score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    // Old function used to spawn Debris, currently not being used
    
    func updateDebris() {
        spawnTimer += fixedDelta
        
        if spawnTimer >= spawnerFixedDelta {
            if debris == nil {
                return
            }
            if let newDebris = debris.copy() as? SKSpriteNode {
                newDebris.physicsBody?.affectedByGravity = true
                newDebris.physicsBody?.isDynamic = true
                newDebris.physicsBody?.allowsRotation = false
                newDebris.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.random(in: -1...1), duration: 5.0)))
                newDebris.physicsBody?.categoryBitMask = PhysicsCategory.debris
                newDebris.physicsBody?.contactTestBitMask = PhysicsCategory.beamNode
                newDebris.physicsBody?.collisionBitMask = PhysicsCategory.ship
                newDebris.name = "debris"
                // NOTE: gets random element in array
                newDebris.texture =  SKTexture(imageNamed: debrisTexture.randomElement()!)
                
                let randomPositionX  = CGFloat.random(in: 0..<size.width)
                let positionX = CGFloat(randomPositionX)
                newDebris.position.x = positionX
                newDebris.position.y = (view?.bounds.height)!
                
                
                self.addChild(newDebris)
                newDebris.zPosition = 100
                
                spawnedDebris += 1
                
                spawnTimer = 0
                
            }
        }
    }
    
    // function used to detect if the beam is making contact with a debris
    func didBegin(_ contact: SKPhysicsContact)  {
        print("BEAM BEAM\(Int.random(in: 0...1000))")
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
            print("touched 1")
        } else {
            print("touched 2")
        }
        
        checkBeamCollision(contact)
    }
    
    // Function that checks if the body is a node and a beam when they collide, then removes both the beam and node. Problem changes is the value of the debris is equal to the answer of the math problem
    func checkBeamCollision(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        if bodyA.categoryBitMask == PhysicsCategory.beamNode {
            let debris = bodyB.node as! Debris
            bodyA.node?.removeFromParent()
            bodyB.node?.removeFromParent()
            if debris.number == (arg1!+arg2!) {
                print("success")
                createMathProblem()
            }
            score += debris.number
            print(debris.number)
            scoreUpdate(score: score)
            print("bodyA")
        } else if bodyB.categoryBitMask == PhysicsCategory.beamNode {
            guard let debris = bodyA.node as? Debris else {return}
            
            bodyB.node?.removeFromParent()
            bodyA.node?.removeFromParent()
            if debris.number == (arg1!+arg2!) {
                print("sucess")
                createMathProblem()
            }
            score += debris.number
            print(debris.number)
            scoreUpdate(score: score)
            print("bodyB")
        }
        
    }
    
    
}
