//
//  Scene.swift
//  AppleMaze
//
//  Created by Jeff Martin on 8/30/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import SpriteKit

protocol SceneDelegate: SKSceneDelegate, AnyObject {
    var hasPowerup: Bool { get set }
    var playerDirection: PlayerDirection { get set }
    
    func scene(_ scene: Scene, didMoveToView view: SKView)
}

class Scene: SKScene {
    static let cellWidth: CGFloat = 27.0
    weak var sceneDelegate: SceneDelegate?
    
    override init(size: CGSize) {
        super.init(size: size)
        L.og?[self]?("Scene.init size: \(size)")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Scene.init(coder:) not implemented")
    }
    
    override func didMove(to view: SKView) {
        sceneDelegate?.scene(self, didMoveToView: view)
    }

    func point(forGridPosition gridPosition: vector_int2) -> CGPoint {
        CGPoint(x: CGFloat(gridPosition.x) * Scene.cellWidth + Scene.cellWidth / 2, y: CGFloat(gridPosition.y) * Scene.cellWidth + Scene.cellWidth / 2)
    }
    
    #if os(macOS)
    override func keyDown(with event: NSEvent) {
        L.og?[self]?("Scene.keyDown with: \(event)")
        switch Int(event.characters!.unicodeScalars.first!.value) {
        case NSLeftArrowFunctionKey:
            sceneDelegate!.playerDirection = .left
        case NSRightArrowFunctionKey:
            sceneDelegate!.playerDirection = .right
        case NSDownArrowFunctionKey:
            sceneDelegate!.playerDirection = .down
        case NSUpArrowFunctionKey:
            sceneDelegate!.playerDirection = .up
        case Int(" ".unicodeScalars.first!.value): // space
            sceneDelegate!.hasPowerup = true
        default:
            L.og?[self]?("Scene.keyDown unknown key")
            break
        }
    }
    #endif
}
