//
//  CellData.swift
//  GameOfLife
//
//  Created by user on 12/09/2015.
//  Copyright (c) 2015 LucyandAnna. All rights reserved.
//

import Foundation

class CellData {
    var isActive: Bool = false
    
    func setState(newIsActive: Bool) {
        isActive = newIsActive
    }
    
    func changeState() {
        isActive = !isActive
    }
    
    func getIsActive() -> Bool {
        return isActive
    }
}