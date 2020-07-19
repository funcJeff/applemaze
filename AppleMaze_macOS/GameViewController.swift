//
//  GameViewController.swift
//  AppleMaze macOS
//
//  Created by Jeff Martin on 9/8/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {
    let game:Game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.scene.scaleMode = .aspectFit
        let skView = view as! SKView
        skView.presentScene(game.scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
}

