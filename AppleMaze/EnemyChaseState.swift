//
//  EnemyChaseState.swift
//  AppleMaze
//
//  Created by Jeff Martin on 8/31/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import GameplayKit

class EnemyChaseState: EnemyState {
    let ruleSystem = GKRuleSystem()
    var scatterTarget: GKGridGraphNode?
    var isHunting: Bool = false {
        willSet {
            if isHunting != newValue {
                if !newValue {
                    let positions = game.random.arrayByShufflingObjects(in: game.level.enemyStartPositions) as! [GKGridGraphNode]
                    scatterTarget = positions.first
                }
            }
        }
    }
    
    override init(game: Game, entity: Entity) {
        super.init(game: game, entity: entity)
        L.og?[self]?("EnemyChaseState.init game: \(game), entity: \(entity)")
        let playerFar = NSPredicate(format: "$distanceToPlayer.floatValue >= 10.0")
        ruleSystem.add(GKRule(predicate: playerFar, assertingFact: NSString("hunt"), grade: 1.0))
        
        let playerNear = NSPredicate(format: "$distanceToPlayer.floatValue < 10.0")
        ruleSystem.add(GKRule(predicate: playerNear, retractingFact: NSString("hunt"), grade: 1.0))
    }
    
    func pathToPlayer() -> [GKGridGraphNode] {
        let graph = game.level.pathfindingGraph
        let playerNode = graph.node(atGridPosition: game.player.gridPosition)!
        return path(toNode: playerNode)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is EnemyFleeState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        let component = entity.component(ofType: SpriteComponent.self)!
        component.use(appearance: .normal)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let position = entity.gridPosition
        if position.x == scatterTarget?.gridPosition.x && position.y == scatterTarget?.gridPosition.y {
            isHunting = true
        }
        
        let distanceToPlayer = pathToPlayer().count
        ruleSystem.state["distanceToPlayer"] = distanceToPlayer
        
        ruleSystem.reset()
        ruleSystem.evaluate()
        
        isHunting = ruleSystem.grade(forFact: NSString("hunt")) > 0.0
        if isHunting {
            startFollowing(path: pathToPlayer())
        } else {
            startFollowing(path: path(toNode: scatterTarget!))
        }
    }
}
