//
//  GameOfLifeScene.swift
//  GameOfLife
//
//  Created by user on 06/09/2015.
//  Copyright (c) 2015 LucyandAnna. All rights reserved.
//
import SpriteKit

let backColor = SKColor(red: 152/255.0, green: 43/255.0, blue: 89/255.0, alpha: 1.0)
let boardColor = SKColor(red: 155/255.0, green: 44/255.0, blue: 89/255.0, alpha: 1.0)
let hiddenTileColor = SKColor(red: 111/255.0, green: 32/255.0, blue: 89/255.0, alpha: 1.0)
let activeTileColor = SKColor(red: 230/255.0, green: 32/255.0, blue: 23/255.0, alpha: 1.0)
let visibleEdgeColor = SKColor(red: 177/255.0, green: 66/255.0, blue: 97/255.0, alpha: 1.0)
let visibleTileColor = SKColor(red: 204/255.0, green: 77/255.0, blue: 97/255.0, alpha: 1.0)
let tileNumberColor = SKColor(red: 245/255.0, green: 203/255.0, blue: 198/255.0, alpha: 1.0)
let labelColor = SKColor(red: 231/255.0, green: 220/255.0, blue: 227/255.0, alpha: 1.0)

let touchHoldTimeThreshold = 0.3

let fontName = "AvenirNext-Bold"
let tileNumberFontSize: CGFloat = 20.0
let tileLabelFontSize: CGFloat = 36.0
let bombCountFontSize: CGFloat = 24.0
let tileCountFontSize: CGFloat = 24.0
let faceFontSize: CGFloat = 20.0
let labelXPadding: CGFloat = 10.0
let labelYPadding: CGFloat = 14.0

class GameOfLifeScene: SKScene {
    
    var gameModel = GameOfLifeMain()
    
    var boardNode: SKSpriteNode
    var tileNodes = [SKSpriteNode]()
    var bombCountNode: SKLabelNode
    var faceNode: SKLabelNode
    var tileCountNode: SKLabelNode
    
    var tileSpacing: Int
    var tileSize: Int
    
    var currentTouchStartTime: NSDate?
    
    override init(size: CGSize)  {
        func tileSizing(screenSize: CGSize) -> (Int, Int) {
            let tileXSpacing = screenSize.width / CGFloat(numberOfCols)
            let tileYSpacing = (screenSize.height - faceFontSize - labelYPadding) / CGFloat(numberOfRows)
            let tileSpacing = Int(tileXSpacing < tileYSpacing ? tileXSpacing : tileYSpacing)
            let tileSize = tileSpacing - 2
            return (tileSize, tileSpacing)
        }
        
        (tileSize, tileSpacing) = tileSizing(size)
        let (boardWidth, boardHeight) = (tileSpacing * numberOfCols, tileSpacing * numberOfRows)
        
        boardNode = SKSpriteNode(color: boardColor, size: CGSize(width: boardWidth, height: boardHeight))
        boardNode.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        let boardXPadding = (size.width - CGFloat(boardWidth)) / 2.0
        let boardYPadding = boardXPadding
        boardNode.position = CGPoint(x: boardXPadding, y: boardYPadding)
        
        let labelYPosition = boardNode.position.y + boardNode.size.height + labelYPadding
        bombCountNode = SKLabelNode(fontNamed: fontName)
        bombCountNode.fontSize = bombCountFontSize
        bombCountNode.fontColor = labelColor
        bombCountNode.position = CGPoint(x: size.width - labelXPadding, y: labelYPosition)
        bombCountNode.horizontalAlignmentMode = .Right
        
        faceNode = SKLabelNode(fontNamed: fontName)
        faceNode.fontSize = faceFontSize
        faceNode.position = CGPoint(x: size.width / 2, y: labelYPosition)
        
        tileCountNode = SKLabelNode(fontNamed: fontName)
        tileCountNode.fontSize = tileCountFontSize
        tileCountNode.fontColor = labelColor
        tileCountNode.position = CGPoint(x: labelYPadding, y: labelYPosition)
        tileCountNode.horizontalAlignmentMode = .Left
        
        super.init(size: size)
        self.backgroundColor = backColor
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.addChild(boardNode)
        self.addChild(faceNode)
        self.addChild(bombCountNode)
        self.addChild(tileCountNode)
        subscribeToNotifications()
        gameModel.startGame()
    }
    
    func subscribeToNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDrawStartingBoard:", name: "DrawStartingBoardNotification", object: nil)
    }
    
    
    
    func handleDrawStartingBoard(notif: NSNotification) { drawBoard() }
    
    func handleSetNumberForTileAt(notification: NSNotification) {
        if let rowVal: AnyObject! = notification.userInfo?["Row"] {
            if let colVal: AnyObject! = notification.userInfo?["Col"] {
                if let numVal: AnyObject! = notification.userInfo?["Num"] {
                    
                    
                }
            }
        }
    }
    
    func drawBoard() {
        faceNode.text = "Number of live cells : 6"
        addTilesToBoard()
    }
    
    func addTilesToBoard() {
        for row in 0..<numberOfRows {
            for col in 0..<numberOfCols {
                var tileNode = SKSpriteNode(color: hiddenTileColor, size: CGSize(width: tileSize, height: tileSize))
                tileNode.position = CGPoint(x: col * tileSpacing + (tileSpacing / 2), y: row * tileSpacing + (tileSpacing / 2))
                tileNodes.append(tileNode)
                boardNode.addChild(tileNode)
            }
        }
        
        tileNodeAt(3, col:4).addChild(tileLabelNode("😀"))
        tileNodeAt(1, col:5).addChild(tileLabelNode("😀"))
        tileNodeAt(1, col:6).addChild(tileLabelNode("😀"))
        tileNodeAt(2, col:6).addChild(tileLabelNode("😀"))
        tileNodeAt(3, col:5).addChild(tileLabelNode("😀"))
        tileNodeAt(4, col:4).addChild(tileLabelNode("😀"))
    }
    
    func flagTileAt(row: Int, col: Int) {
        //   tileNodeAt(row, col: col).addChild(tileLabelNode("❌"))
    }
    
    func unflagTileAt(row: Int, col: Int) {
        clearTile(row, col: col)
    }
    
    func clearTile(row: Int, col: Int) {
        for childNode : AnyObject in tileNodeAt(row, col: col).children {
            childNode.removeFromParent()
        }
    }
    
    func tileNodeAt(row: Int, col: Int) -> SKSpriteNode {
        return tileNodes[row * numberOfCols + col]
    }
    
    func rowNumberAtY(y: CGFloat) -> Int {
        return Int(y) / tileSpacing
    }
    
    func colNumberAtX(x: CGFloat) -> Int {
        return Int(x) / tileSpacing
    }
    
    func tileLabelNode(text: String) -> SKNode {
        var labelNode = SKLabelNode()
        labelNode.fontColor = tileNumberColor
        labelNode.fontName = fontName
        labelNode.fontSize = tileLabelFontSize
        labelNode.text = "\(text)"
        labelNode.verticalAlignmentMode = .Center
        return labelNode
    }
}