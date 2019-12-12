//
//  MenuScene.swift
//  SpaceMath
//
//  Created by MattHew Phraxayavong on 12/3/19.
//  Copyright © 2019 Matthew Phraxayavong. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class MenuScene: SKScene {
    var gameTitle = SKLabelNode()
    var playButton = SKShapeNode()
    var game = GameScene()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        if let view = self.view {
            //Create game title
            self.gameTitle.zPosition = 2
            self.gameTitle.position = CGPoint(x: view.bounds.width/2, y: (view.bounds.height / 2) + 20)
            self.gameTitle.fontSize = 60
            self.gameTitle.text = "Space Math"
            self.gameTitle.fontColor = SKColor.red
            //Create play button
            playButton = SKShapeNode()
            playButton.name = "play_button"
            playButton.zPosition = 2
            playButton.position = CGPoint(x: view.bounds.width/2, y: gameTitle.position.y - 100)
            playButton.fillColor = SKColor.cyan
            let topCorner = CGPoint(x: -50, y: 50)
            let bottomCorner = CGPoint(x: -50, y: -50)
            let middle = CGPoint(x: 50, y: 0)
            let path = CGMutablePath()
            path.addLine(to: topCorner)
            path.addLines(between: [topCorner, bottomCorner, middle])
            playButton.path = path
            
        }
        addChild(gameTitle)
        addChild(playButton)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "play_button" {
                    startGame()
                }
            }
        }
    }
    
    func startGame() {
        if let gameScene = SKScene(fileNamed: "GameScene") {
            gameScene.scaleMode = scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameScene, transition: reveal)
            print("should have presented menu")
        }
        
    }
    
}
