//
//  SpriteComponent.swift
//  AppleMaze
//
//  Created by Jeff Martin on 8/30/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import GameplayKit

class SpriteComponent: GKComponent {
    var sprite: SpriteNode?
    var pulseEffectEnabled: Bool = false
    
    init(defaultColor: SKColor) {
        self.defaultColor = defaultColor
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Appearence
    let defaultColor: SKColor
    
    enum Appearance {
        case normal
        case flee
        case defeated
    }
    
    func use(appearance: Appearance) {
        switch appearance {
        case .normal:
            sprite?.color = defaultColor
        case .flee:
            sprite?.color = SKColor.white
        case .defeated:
            sprite?.run(SKAction.scale(to: 0.25, duration: 0.25))
        }
    }
    
    // MARK: - Movement
    private var _gridPosition = vector_int2(x: 0, y: 0)
    func set(next gridPosition:vector_int2) {
        guard _gridPosition.x != gridPosition.x || _gridPosition.y != gridPosition.y else { return }
        _gridPosition = gridPosition
        let action = SKAction.move(to: (sprite?.scene as? Scene)?.point(forGridPosition: _gridPosition) ?? CGPoint.zero, duration: 0.35)
        let update = SKAction.run {
            (self.entity as? Entity)?.gridPosition = self._gridPosition
        }
        
        sprite?.run(SKAction.sequence([action, update]), withKey: "move")
    }
    
    func warp(toGridPosition gridPosition: vector_int2) {
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let warp = SKAction.move(to: (sprite?.scene as? Scene)?.point(forGridPosition: gridPosition) ?? CGPoint.zero, duration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let update = SKAction.run {
            (self.entity as? Entity)?.gridPosition = gridPosition
        }
        
        sprite?.run(SKAction.sequence([fadeOut, update, warp, fadeIn]))
    }
    
    func follow(path: [GKGridGraphNode], completionHandler:@escaping () -> ()) {
        let allButFirst: ArraySlice<GKGridGraphNode> = path[1 ..< path.endIndex]
        var sequence = [SKAction]()
        sequence.reserveCapacity(allButFirst.count)
        
        for node in allButFirst {
            let point = (sprite?.scene as? Scene)?.point(forGridPosition: node.gridPosition) ?? CGPoint.zero
            sequence.append(SKAction.move(to: point, duration: 0.15))
            sequence.append(SKAction.run { (self.entity as? Entity)?.gridPosition = node.gridPosition })
        }
        sequence.append(SKAction.run(completionHandler))
        sprite?.run(SKAction.sequence(sequence))
    }
}
