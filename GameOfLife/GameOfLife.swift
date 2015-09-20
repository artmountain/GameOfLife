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

import Foundation
func randomIntUpTo(n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

class GameOfLifeMain {
    var cellArray = [[CellData]]()
    var timer = NSTimer()
    var i = 0

    var isRunning = false
    
    init() {}
    
    func startGame() {
        setupTiles()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "updateDiagonal", userInfo: nil, repeats: true)
    }
    
    func setupTiles() {
        cellArray = [[CellData]](count: numberOfRows, repeatedValue: [CellData](count: numberOfCols, repeatedValue: CellData()))
        for(var row: Int = 0; row < numberOfRows; ++row) {
            for(var col: Int = 0; col < numberOfCols; ++col) {
                cellArray[row][col] = CellData()
            }
        }
        notifyView("DrawStartingBoardNotification")
        
        setStartConfiguration()
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
    
    func setStartConfiguration() {
        changeCellState(3, col: 5)
        changeCellState(4, col: 5)
        changeCellState(5, col: 5)
       // changeCellState(3, col: 5)
        //changeCellState(5, col: 5)
    }
    
    func evolve() {
        // Loop through all cells counting the number of neighbours
        for(var row: Int = 0; row < numberOfRows; ++row) {
            for(var col: Int = 0; col < numberOfCols; ++col) {
                // Get this cell
                var thisCell: CellData = cellArray[row][col]
                
                // Start the count of live neighbours at zero
                thisCell.setNeighboursToZero()
                
                // Calculate the number of live neighbours for this cell
                for (var iRow: Int = max(row-1, 0); iRow < min(row+2, numberOfRows) ; ++iRow) {
                    for (var iCol: Int = max(col-1, 0); iCol < min(col+2, numberOfCols) ; ++iCol) {
                        var isMiddleCell:Bool = (iRow == row) && (iCol == col)
                        if (cellArray[iRow][iCol].isActive() && !isMiddleCell) {
                            thisCell.incrementNeighbours()
                        }
                    }
                }
            }
        }
        
        // Loop through all cells applying the evolution rules and updating the screen
        for(var row: Int = 0; row < numberOfRows; ++row) {
            for(var col: Int = 0; col < numberOfCols; ++col) {
                var thisCell: CellData = cellArray[row][col]
                var neighbours: Int = thisCell.getNeighbours()
                
                // See if cell becomes alive
                if ((neighbours == 3) && (thisCell.isActive() == false)) {
                    changeCellState(row, col: col)
                }
                
                // See if cell dies
                //if ((4 > neighbours) && (neighbours > 1)
                if (!((neighbours == 2) || (neighbours == 3)) && (thisCell.isActive() == true)) {
                    changeCellState(row, col: col)// (false)
                }
                
                // Lucy - what are the rules?
                // They depend on
                // 1. The number of neighbours
                // 2 Whether the cell is currently active
                //
                // You need to use boolean AND (&&)
                
                //if (neighbours = 1 < && > 4) && (true) {
                
            }
        }
    }
    
    func changeCellState(row: Int, col: Int) {
        var thisCell: CellData = cellArray[row][col]
        thisCell.changeState()
        if (thisCell.isActive()) {
            notifyView("PopulateTileAtNotification", info: ["Row": row, "Col": col, "Num": 0]);
        } else {
            notifyView("ClearTileAtNotification", info: ["Row": row, "Col": col, "Num": 0]);
        }
    }
    
    func notifyView(name: String, info: Dictionary<String, Int>? = nil) {
        if let userInfo = info {
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil, userInfo: userInfo)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
        }
    }
}
