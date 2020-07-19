//
//  IntelligenceComponent.swift
//  AppleMaze
//
//  Created by Jeff Martin on 8/31/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import GameplayKit

class IntelligenceComponent: GKComponent {
    let stateMachine: GKStateMachine
    let enemy: Entity
    let startingPosition: GKGridGraphNode
    
    init(game: Game, enemy: Entity, startingPosition: GKGridGraphNode) {
        self.enemy = enemy
        self.startingPosition = startingPosition
        let chase = EnemyChaseState(game: game, entity: enemy)
        let flee = EnemyFleeState(game: game, entity: enemy)
        let defeated = EnemyDefeatedState(game: game, entity: enemy, respawnPosition: startingPosition)
        let respawn = EnemyRespawnState(game: game, entity: enemy)
        stateMachine = GKStateMachine(states: [chase, flee, defeated, respawn])
        stateMachine.enter(EnemyChaseState.self)
        super.init()
        L.og?[self]?("IntelligenceComponent.init game: \(game), enemy: \(String(describing: entity)), startingPosition: \(startingPosition)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("IntelligenceComponent.init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        stateMachine.update(deltaTime: seconds)
    }
}
