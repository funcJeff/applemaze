//
//  ContactCategory.swift
//  AppleMaze
//
//  Created by Jeff Martin on 8/31/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

struct ContactCategory: OptionSet {
    let rawValue: UInt32
    
    static let player = ContactCategory(rawValue: 1 << 1)
    static let enemy = ContactCategory(rawValue: 1 << 2)
}
