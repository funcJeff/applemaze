//
//  Entity.swift
//  AppleMaze
//
//  Created by Jeff Martin on 8/30/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import GameplayKit

class Entity: GKEntity {
    var gridPosition: vector_int2
    
    init(gridPosition: vector_int2) {
        self.gridPosition = gridPosition
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Entity.init(coder:) has not been implemented")
    }
}
