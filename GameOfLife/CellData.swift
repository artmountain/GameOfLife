 //
//  CellData.swift
//  GameOfLife
//
//  Created by user on 12/09/2015.
//  Copyright (c) 2015 LucyandAnna. All rights reserved.
//

import Foundation

class CellData {
    var active: Bool = false
    var neighbours: Int = 0
    
    func setState(newActive: Bool) {
        active = newActive
    }
    
    func changeState() {
        active = !active
    }
    
    func isActive() -> Bool {
        return active
    }
    
    func setNeighboursToZero() {
        neighbours = 0
    }
    
    func incrementNeighbours() {
        ++neighbours
    }
    
    func getNeighbours() -> Int {
        return neighbours
    }
}