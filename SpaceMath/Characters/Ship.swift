//
//  Ship.swift
//  SpaceMath
//
//  Created by MattHew Phraxayavong on 12/3/19.
//  Copyright © 2019 Matthew Phraxayavong. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Ship: SKSpriteNode {
    
    var beam = SKNode()
//    var beam: SKNode!
    
    func initBody() {
        self.shipsBody()
    }
    
    // MARK: - class methods
    
    
    // NOTE: this method give a physicbody to the ship
    private func shipsBody() {
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.ship
    }
    
    // NOTE: this method takes care of ships firing beam func
    func fireBeam(scene: SKScene) {
        if let scene = scene as? GameScene {
            let newBeam = beam.copy() as! SKNode
                    newBeam.physicsBody? = SKPhysicsBody(rectangleOf: CGSize(width: 3, height: 25))
                    newBeam.physicsBody?.affectedByGravity = false
                    newBeam.physicsBody?.isDynamic = true
                    newBeam.physicsBody?.allowsRotation = false
                    newBeam.physicsBody?.categoryBitMask = PhysicsCategory.beamNode
                    newBeam.physicsBody?.contactTestBitMask = PhysicsCategory.debris
                    let forward = SKAction.applyForce(CGVector(dx: 0, dy: 50), duration: 99)
                    newBeam.run(forward)
                    newBeam.name = "beam"
                    /* Generate new obstacle position, start just outside screen and with a random y value */
//            let randomPosition = CGPoint(x: scene.mainShip.position.x + (self.size.width/2), y: self.size.height - 90)
            let randomPosition = CGPoint(x: scene.mainShip.position.x, y: scene.mainShip.position.y + (scene.mainShip.size.height/2))

            //        let randomPosition = CGPoint(x: self.position.x + 150, y: self.position.y)
                    /* Convert new node position back to scene space */
            //        newBeam.position = self.convert(randomPosition, to: self)
                    newBeam.position = randomPosition
                    
                    scene.addChild(newBeam)
        }
        

    }
    
    // NOTE: Checking if beam collides with asteroid
    func checkBeamCollision(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == PhysicsCategory.beamNode {
            contact.bodyA.node?.removeFromParent()
        } else if contact.bodyB.categoryBitMask == PhysicsCategory.beamNode {
            contact.bodyB.node?.removeFromParent()
        }
    }
    
    func checkDebrisCollision(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == PhysicsCategory.debris {
            contact.bodyA.node?.removeFromParent()
        } else if contact.bodyB.categoryBitMask == PhysicsCategory.debris {
            contact.bodyB.node?.removeFromParent()
        }
    }
    
    
}
