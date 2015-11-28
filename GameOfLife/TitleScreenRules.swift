//
//  TitleScreenRules.swift
//  GameOfLife
//
//  Created by user on 14/11/2015.
//  Copyright (c) 2015 LucyandAnna. All rights reserved.
//
import SpriteKit
import Foundation

class TitleScreenRules: SKScene {
    override init(size: CGSize)  {
        super.init(size: size)
        
        let titleNode = SKLabelNode(fontNamed: fontName)
        titleNode.fontSize = titleFontSize
        titleNode.position = CGPoint(x: size.width / 2, y: size.height - 100)
        titleNode.text = "Game of life rules"
        self.addChild(titleNode)
        
        let sprite = SKSpriteNode(imageNamed:"rules")
        sprite.xScale = 0.9
        sprite.yScale = 0.9
        sprite.position = CGPoint(x: size.width / 2, y: size.height - 270)
        self.addChild(sprite)
        
        self.backgroundColor = SKColor.redColor() //SKColor(red: 231/255.0, green: 220/255.0, blue: 227/255.0, alpha: 1.0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // Transition to Game of Life
            var gameScene = GameOfLifeScene(size: self.size)
            var transition = SKTransition.flipVerticalWithDuration(3.0)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
    }

}