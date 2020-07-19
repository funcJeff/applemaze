//
//  EnemyRespawnState.swift
//  AppleMaze
//
//  Created by Jeff Martin on 8/31/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import GameplayKit

class EnemyRespawnState: EnemyState {
    static let defaultRespawnTime: TimeInterval = 10
    var timeRemaining: TimeInterval = 0
    
    override init(game: Game, entity: Entity) {
        super.init(game: game, entity: entity)
        L.og?[self]?("EnemyRespawnState.init game: \(game), entity: \(entity)")
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is EnemyChaseState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        self.timeRemaining = EnemyRespawnState.defaultRespawnTime
        let component = entity.component(ofType: SpriteComponent.self)!
        component.pulseEffectEnabled = true
    }
    
    override func willExit(to nextState: GKState) {
        let component = entity.component(ofType: SpriteComponent.self)!
        component.pulseEffectEnabled = false
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        timeRemaining -= seconds
        if timeRemaining < 0 {
            stateMachine!.enter(EnemyChaseState.self)
        }
    }
}
