//
//  EnemyState.swift
//  AppleMaze
//
//  Created by Jeff Martin on 8/31/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import GameplayKit

class EnemyState: GKState {
    unowned let game: Game
    let  entity: Entity

    init(game: Game, entity: Entity) {
        self.game = game
        self.entity = entity
    }

    func path(toNode node: GKGridGraphNode) -> [GKGridGraphNode] {
        let graph = game.level.pathfindingGraph
        let enemyNode = graph.node(atGridPosition: entity.gridPosition)!
        let path = graph.findPath(from: enemyNode, to: node) as! [GKGridGraphNode]
        return path
    }
    
    func startFollowing(path: [GKGridGraphNode]) {
        /*
         Set up a move to the first node on the path, but
         no farther because the next update will recalculate the path.
         */
        if path.count > 1 {
            let firstMove = path[1] // path[0] is the enemy's current position.
            let component = entity.component(ofType: SpriteComponent.self)!
            component.set(next:firstMove.gridPosition)
        }
    }
}
