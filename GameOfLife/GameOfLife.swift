//
//  GameOfLife.swift
//  GameOfLife
//
//  Created by user on 06/09/2015.
//  Copyright (c) 2015 LucyandAnna. All rights reserved.
//

import Foundation

var numberOfRows = 10
var numberOfCols = 10

enum Tile {
    case Populated
    case Free
}

import Foundation
func randomIntUpTo(n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

class GameOfLifeMain {
    var timer = NSTimer()

    var tiles = Array(count: numberOfRows * numberOfCols, repeatedValue: Tile.Free)
    var i = 0

    var isRunning = false
    
    init() {}
    
    func startGame() {
        setupTiles()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "updateDiagonal", userInfo: nil, repeats: true)
    }
    
    func setupTiles() {
        notifyView("DrawStartingBoardNotification")
    }
    
    func setState(newIsRunning: Bool) {
        isRunning = newIsRunning
    }
    
    @objc func updateDiagonal() {
        if isRunning == true {
            notifyView("PopulateTileAtNotification", info: ["Row": i, "Col": i, "Num": 0]);
            i = (i + 1) % numberOfRows
            var cellToDelete = (i - 3 + numberOfRows) % numberOfRows
            notifyView("ClearTileAtNotification", info: ["Row": cellToDelete, "Col": cellToDelete, "Num": 0]);
        }
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