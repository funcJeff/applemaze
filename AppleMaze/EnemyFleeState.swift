//
//  EnemyFleeState.swift
//  AppleMaze
//
//  Created by Jeff Martin on 8/31/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import GameplayKit

class EnemyFleeState: EnemyState {
    var target: GKGridGraphNode?
    
    override init(game: Game, entity: Entity) {
        super.init(game: game, entity: entity)
        L.og?[self]?("EnemyFellState.init game: \(game), entity: \(entity)")
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is EnemyChaseState.Type || stateClass is EnemyDefeatedState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        let component = entity.component(ofType: SpriteComponent.self)!
        component.use(appearance: .flee)
        target = game.random.arrayByShufflingObjects(in: game.level.enemyStartPositions).first as? GKGridGraphNode
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let position = entity.gridPosition
        if position.x == target?.gridPosition.x && position.y == target?.gridPosition.y {
            target = game.random.arrayByShufflingObjects(in: game.level.enemyStartPositions).first as? GKGridGraphNode
        }
        startFollowing(path: path(toNode: target!))
    }
}
