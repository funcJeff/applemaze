//
//  GameViewController.swift
//  AppleMaze tvOS
//
//  Created by Jeff Martin on 9/8/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
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
