//
//  PhysicsCategory.swift
//  SpaceMath
//
//  Created by MattHew Phraxayavong on 12/3/19.
//  Copyright © 2019 Matthew Phraxayavong. All rights reserved.
//

import Foundation


struct PhysicsCategory{
    static let None: UInt32 = 0
    static let ship: UInt32 = 0b1
    static let debris: UInt32 = 0b10
    static let beamNode: UInt32 = 0b100
}
