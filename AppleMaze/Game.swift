//
//  Game.swift
//  AppleMaze
//
//  Created by Jeff Martin on 8/28/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import GameplayKit

class Game: NSObject, SceneDelegate, SKPhysicsContactDelegate {
    private(set) var scene: Scene
    private(set) var level = Level()
    private(set) var enemies = [Entity]()
    private(set) var player: Entity
    
    var random = GKRandomSource()
    private let intelligenceSystem = GKComponentSystem(componentClass: IntelligenceComponent.self)
    private var prevUpdateTime: TimeInterval = 0
    
    static let powerupDuration: TimeInterval = 15
    
    private var powerupTimeRemaining: TimeInterval = 0 {
        didSet {
            if powerupTimeRemaining < 0 {
                hasPowerup = false
            }
        }
    }
    
    override init() {
        player = Entity(gridPosition: level.startPosition.gridPosition)
        player.addComponent(SpriteComponent(defaultColor: SKColor.cyan))
        player.addComponent(PlayerControlComponent(level: level))
        scene = Scene(size: CGSize(width: level.width * Int(Scene.cellWidth), height: level.height * Int(Scene.cellWidth)))
        super.init()
        
        L.og?[self]?("Game.init")
        let colors = [SKColor.red, SKColor.green, SKColor.yellow, SKColor.magenta]
        for (i, node) in level.enemyStartPositions.enumerated() {
            let enemy = Entity(gridPosition: node.gridPosition)
            enemy.addComponent(SpriteComponent(defaultColor: colors[i]))
            enemy.addComponent(IntelligenceComponent(game: self, enemy: enemy, startingPosition: node))
            intelligenceSystem.addComponent(foundIn: enemy)
            enemies.append(enemy)
        }
        scene.sceneDelegate = self
        scene.delegate = self
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        scene.physicsWorld.contactDelegate = self
    }
    
    func update(_ currentTime: TimeInterval, for scene: SKScene) {
        let dt = currentTime - prevUpdateTime
        prevUpdateTime = currentTime
        powerupTimeRemaining -= dt
        intelligenceSystem.update(deltaTime: dt)
        player.update(deltaTime: dt)
    }
    
    // MARK: - SceneDelegate
    
    var hasPowerup = false {
        didSet {
            if hasPowerup != oldValue {
                let nextState: AnyClass
                if hasPowerup {
                    nextState = EnemyFleeState.self
                } else {
                    nextState = EnemyChaseState.self
                }
                
                for component in intelligenceSystem.components as! [IntelligenceComponent] {
                    component.stateMachine.enter(nextState)
                }
                powerupTimeRemaining = Game.powerupDuration
            }
        }
    }
    
    var playerDirection: PlayerDirection {
        set {
            L.og?[self]?("Game.playerDirection.set newValue = \(newValue)")
            let component = player.component(ofType: PlayerControlComponent.self)!
            component.attemptedDirection = newValue
        }
        get {
            let component = player.component(ofType: PlayerControlComponent.self)!
            L.og?[self]?("Game.playerDirection.get direction = \(component.direction)")
            return component.direction
        }
    }
    
    func scene(_ scene: Scene, didMoveToView view: SKView) {
        L.og?[self]?("Game.scene: \(scene) didMoveToView: \(view)")
        scene.backgroundColor = SKColor.black
        
        let maze = SKNode()
        let cellSize = CGSize(width: Scene.cellWidth, height: Scene.cellWidth)
        let graph = level.pathfindingGraph
        let width = Int(Scene.cellWidth)
        for i  in 0 ..< level.width {
            for j in 0 ..< level.height {
                if graph.node(atGridPosition: vector_int2(Int32(i), Int32(j))) != nil {
                    let node = SKSpriteNode(color: SKColor.gray, size: cellSize)
                    node.position = CGPoint(x: i * width + width / 2, y: j * width + width / 2)
                    maze.addChild(node)
                }
            }
        }
        scene.addChild(maze)
        
        let body = SKPhysicsBody(circleOfRadius: Scene.cellWidth / 2)
        body.categoryBitMask = ContactCategory.player.rawValue
        body.contactTestBitMask = ContactCategory.enemy.rawValue
        body.collisionBitMask = 0
        
        let sprite = SpriteNode(color: SKColor.cyan, size: cellSize)
        sprite.position = scene.point(forGridPosition: player.gridPosition)
        sprite.zRotation = CGFloat.pi / 4
        sprite.xScale = CGFloat(0.5.squareRoot())
        sprite.yScale = CGFloat(0.5.squareRoot())
        sprite.physicsBody = body
        
        let playerComponent = player.component(ofType: SpriteComponent.self)
        sprite.owner = playerComponent
        playerComponent!.sprite = sprite
        scene.addChild(playerComponent!.sprite!)
        
        for entity in enemies {
            let body = SKPhysicsBody(circleOfRadius: Scene.cellWidth / 2)
            body.categoryBitMask = ContactCategory.enemy.rawValue
            body.contactTestBitMask = ContactCategory.player.rawValue
            body.collisionBitMask = 0
            
            let enemyComponent = entity.component(ofType: SpriteComponent.self)!
            enemyComponent.sprite = SpriteNode(color: enemyComponent.defaultColor, size: cellSize)
            enemyComponent.sprite!.owner = enemyComponent
            enemyComponent.sprite!.position = scene.point(forGridPosition: entity.gridPosition)
            enemyComponent.sprite!.physicsBody = body
            scene.addChild(enemyComponent.sprite!)
        }
    }
    
    // MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        var enemyNode: SpriteNode
        if contact.bodyA.categoryBitMask == ContactCategory.enemy.rawValue {
            enemyNode = contact.bodyA.node as! SpriteNode
        } else if contact.bodyB.categoryBitMask == ContactCategory.enemy.rawValue {
            enemyNode = contact.bodyB.node as! SpriteNode
        } else {
            fatalError("Expected player-enemy/enemy-player collision")
        }
        
        let entity = enemyNode.owner?.entity as! Entity
       let aiComponent = entity.component(ofType: IntelligenceComponent.self)!
        if aiComponent.stateMachine.currentState === EnemyChaseState.self {
            playerAttacked()
        } else {
            aiComponent.stateMachine.enter(EnemyDefeatedState.self)
        }
    }
    
    private func playerAttacked() {
        let spriteComponent = player.component(ofType: SpriteComponent.self)!
        spriteComponent.warp(toGridPosition: level.startPosition.gridPosition)
        
        let controlComponent = player.component(ofType: PlayerControlComponent.self)!
        controlComponent.reset(direction: .none)
        controlComponent.attemptedDirection = .none
    }
}
