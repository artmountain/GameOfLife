//
//  BaseScene.swift
//  GameOfLife
//
//  Created by user on 28/11/2015.
//  Copyright (c) 2015 LucyandAnna. All rights reserved.
//

import Foundation
import SpriteKit

class BaseScene: SKScene {
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
}