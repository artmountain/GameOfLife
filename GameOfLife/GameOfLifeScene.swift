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
let buttonColour = SKColor(red: 21/255.0, green: 66/255.0, blue: 109/255.0, alpha: 1.0)

let cellGraphic: String = "/Users/user/Documents/AppAttack/GameOfLife/GameOfLife/Images.xcassets/Spaceship.imageset/Spaceship.png"

let fontName = "AvenirNext-Bold"
let tileLabelFontSize: CGFloat = 36.0
let tileCountFontSize: CGFloat = 24.0
let bombCountFontSize: CGFloat = 24.0
let labelFontSize: CGFloat = 20.0
let titleFontSize: CGFloat = 30.0
let labelXPadding: CGFloat = 10.0
let labelYPadding: CGFloat = 14.0

class GameOfLifeScene: SKScene {
    
    var gameModel = GameOfLifeMain()
    
    var boardNode: SKSpriteNode
    var tileNodes = [SKSpriteNode]()
    var faceNode: SKLabelNode
    var tileCountNode: SKLabelNode
    var xGridSizeNode: SKLabelNode
    //var button: GGButton
    var runNode: SKShapeNode!
    var stopNode: SKShapeNode!
    var oneStepNode: SKShapeNode!
    
    var tileSpacing: Int
    var tileSize: Int
    
    var currentTouchStartTime: NSDate?
    
    override init(size: CGSize)  {
        func tileSizing(screenSize: CGSize) -> (Int, Int) {
            let tileXSpacing = screenSize.width / CGFloat(numberOfCols)
            let tileYSpacing = (screenSize.height - labelFontSize - labelYPadding) / CGFloat(numberOfRows)
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
        xGridSizeNode = SKLabelNode(fontNamed: fontName)
        xGridSizeNode.fontSize = bombCountFontSize
        xGridSizeNode.fontColor = labelColor
        xGridSizeNode.horizontalAlignmentMode = .Right
        
        faceNode = SKLabelNode(fontNamed: fontName)
        faceNode.fontSize = labelFontSize
        faceNode.position = CGPoint(x: size.width / 2, y: labelYPosition)
        
        tileCountNode = SKLabelNode(fontNamed: fontName)
        tileCountNode.fontSize = tileCountFontSize
        tileCountNode.fontColor = labelColor
        tileCountNode.position = CGPoint(x: labelYPadding, y: labelYPosition)
        tileCountNode.horizontalAlignmentMode = .Left
        
        super.init(size: size)
        self.backgroundColor = backColor
        
        runNode = createButton("run", xPos: labelXPadding, yPos: labelYPosition + 200, width: 100, height: 30)
        
        stopNode = createButton("stop", xPos: labelXPadding, yPos: labelYPosition + 100, width: 100, height: 30)
        
        oneStepNode = createButton("move 1 step", xPos: labelXPadding, yPos: labelYPosition + 150, width: 180, height: 30)
        
/*
        func tileLabelNode(text: String) -> SKNode {
            let sprite = SKSpriteNode(imageNamed:"cuteElephant.jpg")
            sprite.xScale = 0.05
            sprite.yScale = 0.05
            
            return sprite
        }
        */
      //  let button = GGButton(defaultButtonImage: "button", activeButtonImage: "button_active", buttonAction: goToGameScene)
      //  button.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
     //   addChild(button)
        
      
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.addChild(boardNode)
        self.addChild(faceNode)
        self.addChild(xGridSizeNode)
        self.addChild(tileCountNode)
        self.addChild(runNode)
        self.addChild(stopNode)
        self.addChild(oneStepNode)
        subscribeToNotifications()
        gameModel.startGame()
    }
    
    func subscribeToNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDrawStartingBoard:", name: "DrawStartingBoardNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlePopulateTileAt:", name: "PopulateTileAtNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleClearTileAt:", name:
            "ClearTileAtNotification", object: nil)
    }
    
    func runFuncWithCoordsFromNotification(f: (Int, Int) -> (), notification: NSNotification) {
        if let rowVal: AnyObject! = notification.userInfo?["Row"] {
            if let colVal: AnyObject! = notification.userInfo?["Col"] {
                let (row, col) = (rowVal as! Int, colVal as! Int)
                f(row, col)
            }
        }
    }
    
    func handleDrawStartingBoard(notif: NSNotification) { drawBoard() }
    func handlePopulateTileAt(notif: NSNotification) { runFuncWithCoordsFromNotification(populateTileAt, notification: notif) }
    func handleClearTileAt(notif: NSNotification) { runFuncWithCoordsFromNotification(clearTileAt, notification: notif) }
    
    func drawBoard() {
        faceNode.text = "Number of live cells : 6"
        xGridSizeNode.text = "Hello"
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
    }
    
    func populateTileAt(row: Int, col: Int) {
        tileNodeAt(row, col: col).addChild(tileLabelNode(cellGraphic))
    }
    
    func clearTileAt(row: Int, col: Int) {
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
        //let sprite = SKSpriteNode(imageNamed:"Spaceship")
        let sprite = SKSpriteNode(imageNamed:"cuteElephant.jpg")
        sprite.xScale = 0.05
        sprite.yScale = 0.05
        
        return sprite
/*
        var labelNode = SKLabelNode()
        labelNode.fontColor = tileNumberColor
        labelNode.fontName = fontName
        labelNode.fontSize = tileLabelFontSize
        labelNode.text = "\(text)"
        labelNode.verticalAlignmentMode = .Center
        return labelNode
*/
}
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func goToGameScene() {
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            if CGRectContainsPoint(boardNode.frame, touch.locationInNode(self)) {                
                let row: Int = getRowFromY(touch.locationInNode(self).y)
                let col: Int = getColFromX(touch.locationInNode(self).x)
                gameModel.changeCellState(row, col: col)
            }
            
            // Check start and stop
            if CGRectContainsPoint(runNode.frame, touch.locationInNode(self)) {
                runButtonPressed()
            }
            if CGRectContainsPoint(stopNode.frame, touch.locationInNode(self)) {
                stopButtonPressed()
            }
            if CGRectContainsPoint(oneStepNode.frame, touch.locationInNode(self)) {
                oneStepButtonPressed()
            }
        }
    }
    
    func getColFromX(x: CGFloat) -> Int {
        return (Int)(x) / tileSpacing
    }
   
    func getRowFromY(y: CGFloat) -> Int {
        return (Int)(y) / tileSpacing
    }
    
    
    func runButtonPressed() {
        gameModel.setState(true)
    }
    
    func stopButtonPressed() {
        gameModel.setState(false)
    }
    
    func oneStepButtonPressed() {
       gameModel.evolve()
    }
    
    
    // Create button
    func createButton(label: String, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat)->SKShapeNode {
        var nodeBox: CGRect = CGRectMake(0, 0, width, height)
        let node = SKShapeNode(rect: nodeBox, cornerRadius: 10)
        node.position = CGPoint(x: xPos, y: yPos)
        node.fillColor = buttonColour
        let nodeLabel = SKLabelNode(fontNamed: fontName)
        nodeLabel.position = CGPoint(x: nodeBox.midX, y: nodeBox.midY)
        nodeLabel.fontSize = tileCountFontSize
        nodeLabel.fontColor = labelColor
        nodeLabel.horizontalAlignmentMode = .Center
        nodeLabel.verticalAlignmentMode = .Center
        nodeLabel.text = label
        node.addChild(nodeLabel)
        return node
    }
    
    /*

    class GGButton: SKNode {
        var defaultButton: SKSpriteNode
        var activeButton: SKSpriteNode
        var action: () -> Void
        
        init(defaultButtonImage: String, activeButtonImage: String, buttonAction: () -> Void) {
            defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
            activeButton = SKSpriteNode(imageNamed: activeButtonImage)
            activeButton.hidden = true
            action = buttonAction
            
            super.init()
            
            userInteractionEnabled = true
            addChild(defaultButton)
            addChild(activeButton)
        }
        
        /**
        Required so XCode doesn't throw warnings
        */
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
            activeButton.hidden = false
            defaultButton.hidden = true
        }
  
        override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
            var touch: UITouch = touches.allObjects[0] as UITouch
            var location: CGPoint = touch.locationInNode(self)
            
            if defaultButton.containsPoint(location) {
                activeButton.hidden = false
                defaultButton.hidden = true
            } else {
                activeButton.hidden = true
                defaultButton.hidden = false
            }
        }
        
        override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
            var touch: UITouch = touches.allObjects[0] as UITouch
            var location: CGPoint = touch.locationInNode(self)
            
            if defaultButton.containsPoint(location) {
                action()
            }
            
            activeButton.hidden = true
            defaultButton.hidden = false
        }
    }
*/
}