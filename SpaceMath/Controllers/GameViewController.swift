//
//  GameViewController.swift
//  SpaceMath
//
//  Created by MattHew Phraxayavong on 12/3/19.
//  Copyright © 2019 Matthew Phraxayavong. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = MenuScene()
//            if let scene = SKScene(fileNamed: "MenuScene") {
                // Set the scale mode to scale to fit the window
                //scene.scaleMode = .aspectFi
                scene.size = self.view.bounds.size
                // Present the scene
                view.presentScene(scene)
                
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsFields = true
            view.showsPhysics = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
