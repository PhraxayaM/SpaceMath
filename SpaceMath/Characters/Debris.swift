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
            self.number = Int.random(in: 1...20)
            
            // gives us a random texture for the debris from the assets
            let texture = SKTexture(imageNamed: debrisTexture.randomElement()!)
            super.init(texture: texture, color: UIColor.clear, size: texture.size())

            name = "debris"
            
            
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center

            label.fontColor = .white
            label.text = "\(self.number)"

            addChild(label)
            label.zPosition = 2
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
