//
//  L.swift
//  AppleMaze iOS
//
//  Created by Jeff Martin on 9/15/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

class L {
    typealias MessageFunc = (String) -> Void
    
    static let defaultCategories = [
        "EnemyChaseState",
        "EnemyFleeState",
        "EnemyRespawnState",
        "Game",
        "IntelligenceComponent",
        "PlayerControlComponent",
        "Scene",
    ]
    static let og: L? = L()
    
    private static func log(_ message: String) {
        print(message)
    }
    
    private let categoryFunc: [String: MessageFunc]
    
    init(categories: [String]? = nil) {
        let categories = categories ?? L.defaultCategories
        categoryFunc = Dictionary(uniqueKeysWithValues: categories.map { ($0, L.log) })
    }
    
    subscript(type: Any) -> MessageFunc? {
        let mirror = Mirror(reflecting: type)
        let typeName = String(describing: mirror.subjectType)
        return categoryFunc[typeName]
    }
}
