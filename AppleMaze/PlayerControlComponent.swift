//
//  PlayerControlComponent.swift
//  AppleMaze
//
//  Created by Jeff Martin on 8/30/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import GameplayKit

class PlayerControlComponent: GKComponent {
    let level: Level
    
    func reset(direction newDirection: PlayerDirection) {
        let proposedNode: GKGridGraphNode?
        if direction != .none, let nextNode = nextNode {
            proposedNode = node(inDirection: direction, fromNode: nextNode)
        } else {
            let currentNode: GKGridGraphNode = level.pathfindingGraph.node(atGridPosition: (entity as? Entity)!.gridPosition)!
            proposedNode = node(inDirection: direction, fromNode: currentNode)
        }
        guard proposedNode != nil else { return }
        direction = newDirection
    }
    
    private(set) var direction: PlayerDirection = .none
    
    var attemptedDirection: PlayerDirection = .none
    private var nextNode: GKGridGraphNode?
    
    init(level: Level) {
        self.level = level
        super.init()
        L.og?[self]?("PlayerControlComponent.init level: \(level)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("PlayerControlComponent.init(coder:) has not been implemented")
    }
    
    func node(inDirection direction: PlayerDirection, fromNode node: GKGridGraphNode) -> GKGridGraphNode? {
        var nextPosition: vector_int2!
        switch direction {
        case .left:
            nextPosition = node.gridPosition &+ vector_int2(-1, 0)
        case .right:
            nextPosition = node.gridPosition &+ vector_int2(1, 0)
        case .down:
            nextPosition = node.gridPosition &+ vector_int2(0, -1)
        case .up:
            nextPosition = node.gridPosition &+ vector_int2(0, 1)
        case .none:
            return nil
        }
        return level.pathfindingGraph.node(atGridPosition: nextPosition)
    }
    
    func makeNextMove() {
        let currentNode = level.pathfindingGraph.node(atGridPosition: (entity as? Entity)!.gridPosition)
        let maybeNextNode = node(inDirection: direction, fromNode: currentNode!)
        let attemptedNextNode = node(inDirection: attemptedDirection, fromNode: currentNode!)
        if attemptedNextNode != nil {
            L.og?[self]?("currentNode = \(currentNode!.gridPosition)")
            L.og?[self]?("attemptedNextNode = \(attemptedNextNode!.gridPosition)")
            direction = attemptedDirection
            nextNode = attemptedNextNode
            let component: SpriteComponent = (entity?.component(ofType: SpriteComponent.self)!)!
            component.set(next:nextNode!.gridPosition)
        } else if attemptedNextNode == nil && maybeNextNode != nil {
            L.og?[self]?("currentNode = \(currentNode!.gridPosition)")
            L.og?[self]?("maybeNextNode = \(maybeNextNode!.gridPosition)")
            let tempDirection = direction
            direction = tempDirection
            nextNode = maybeNextNode
            let component = entity?.component(ofType: SpriteComponent.self)
            component?.set(next:nextNode!.gridPosition)
        } else {
            direction = .none
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        makeNextMove()
    }
}
