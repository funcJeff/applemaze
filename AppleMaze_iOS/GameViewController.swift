//
//  GameViewController.swift
//  AppleMaze iOS
//
//  Created by Jeff Martin on 8/28/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import GameplayKit
import SpriteKit
import UIKit

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

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .all
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
