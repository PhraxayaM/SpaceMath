//
//  Debris.swift
//  SpaceMath
//
//  Created by MattHew Phraxayavong on 12/4/19.
//  Copyright © 2019 Matthew Phraxayavong. All rights reserved.
//

import Foundation
import SpriteKit

class Debris: SKSpriteNode {
    var debrisTexture = ["wingGreen_6", "meteorBrown_big3"]

    var label: SKLabelNode
        var number: Int
        
        init(number: Int = 99) {
            label = SKLabelNode(fontNamed: "Helvetica")
            let s = CGSize(width: 40, height: 40)
    //        self.number = Int(arc4random() % 10)
            self.number = Int.random(in: 1...20)
            
//            super.init(texture: nil, color: .red, size: s)
//            super.init(imageNamed: debrisTexture.randomElement()!)
//            super.init(imageNamed: texture)
//            super.init(imageNamed: "wingGreen_6")
//            self.texture = debrisTexture.randomElement()!
//                var livingNeighbours:Int = 0
            let texture = SKTexture(imageNamed: debrisTexture.randomElement()!)
            super.init(texture: texture, color: UIColor.clear, size: texture.size())
//            self.isHidden = true
//                init() {
//                    // super.init(imageNamed:"bubble") You can't do this because you are not calling a designated initializer.
//                    let texture = SKTexture(imageNamed: "bubble")
//                    super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
//                    self.hidden = true
//                }
//
//                init(texture: SKTexture!) {
//                    //super.init(texture: texture) You can't do this because you are not calling a designated initializer.
//                    super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
//                }
//
//                init(texture: SKTexture!, color: UIColor!, size: CGSize) {
//                    super.init(texture: texture, color: color, size: size)
//                }
//            }
            name = "debris"
            
            
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center
    //        label.position.x = 5
    //        label.position.y = 5
            label.fontColor = .white
            label.text = "\(self.number)"
//            changeTexture(texture: <#T##SKTexture#>)
            
//            
//            self.physicsBody?.categoryBitMask = PhysicsCategory.debris
//            self.physicsBody?.contactTestBitMask = PhysicsCategory.beamNode | PhysicsCategory.ship
//            self.physicsBody?.collisionBitMask = PhysicsCategory.None
//            self.physicsBody?.
//            self.changeTexture(texture: <#T##SKTexture#>)
            addChild(label)
            label.zPosition = 2
        }
    
    func changeTexture(texture: SKTexture) {
        self.texture = texture
    }
    
    func moveDown() {
        let move = SKAction.moveTo(y: -200, duration: 5.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, remove])
        self.run(sequence)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
