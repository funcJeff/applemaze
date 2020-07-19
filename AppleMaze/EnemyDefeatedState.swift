//
//  EnemyDefeatedState.swift
//  AppleMaze
//
//  Created by Jeff Martin on 8/31/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import GameplayKit

class EnemyDefeatedState: EnemyState {
    let respawnPosition: GKGridGraphNode
    
    init(game: Game, entity: Entity, respawnPosition: GKGridGraphNode) {
        self.respawnPosition = respawnPosition
        super.init(game: game, entity: entity)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is EnemyRespawnState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        let component = entity.component(ofType: SpriteComponent.self)!
        component.use(appearance: .defeated)
        
        let graph = game.level.pathfindingGraph
        let enemyNode = graph.node(atGridPosition: entity.gridPosition)
        let path = graph.findPath(from: enemyNode!, to: respawnPosition) as! [GKGridGraphNode]
        component.follow(path: path) {
            self.stateMachine?.enter(EnemyRespawnState.self)
        }
    }
}
