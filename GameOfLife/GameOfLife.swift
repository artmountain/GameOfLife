//
//  GameOfLife.swift
//  GameOfLife
//
//  Created by user on 06/09/2015.
//  Copyright (c) 2015 LucyandAnna. All rights reserved.
//

import Foundation

let numberOfRows = 10
let numberOfCols = 10

enum Tile {
    case Populated
    case Free
}

import Foundation
func randomIntUpTo(n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

class GameOfLifeMain {
    
    var tiles = Array(count: numberOfRows * numberOfCols, repeatedValue: Tile.Free)
    
    init() {}
    
    func startGame() {
        setupTiles()
    }
    /*
    func setupTiles() {
    for i in 0..<numberOfBombs {
    let row = randomIntUpTo(numberOfRows)
    let col = randomIntUpTo(numberOfCols)
    if !tileHasBomb(row, col: col) {
    setTileAt(Tile.Populated, row: row, col: col)
    }
    }
    notifyView("DrawStartingBoardNotification")
    }*/
    
    func setupTiles() {
        notifyView("DrawStartingBoardNotification")
    }
    
    func setTileAt(tile: Tile, row: Int, col: Int) {
        tiles[(row * numberOfCols) + col] = tile
    }
    
    func tileAt(row: Int, col: Int) -> Tile {
        return tiles[(row * numberOfCols) + col]
    }
    
    func performFuncOnCellsAdjacentTo(gridFunc: (Int, Int) -> (), row: Int, col: Int) {
        func boundedGridFunc(r: Int, c: Int) {
            if r >= 0 && r < numberOfRows && c >= 0 && c < numberOfCols {
                return gridFunc(r, c)
            }
        }
        boundedGridFunc(row - 1, col - 1)
        boundedGridFunc(row - 1, col)
        boundedGridFunc(row - 1, col + 1)
        boundedGridFunc(row, col - 1)
        boundedGridFunc(row, col + 1)
        boundedGridFunc(row + 1, col - 1)
        boundedGridFunc(row + 1, col)
        boundedGridFunc(row + 1, col + 1)
    }
    
    func notifyView(name: String, info: Dictionary<String, Int>? = nil) {
        if let userInfo = info {
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil, userInfo: userInfo)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
        }
    }
    
}