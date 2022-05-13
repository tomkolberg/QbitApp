//
//  Label.swift
//  HIWI-APP
//
//  Created by Tom Kolberg on 06.05.22.
//

import SpriteKit
import GameplayKit
import UIKit

class Label: SKScene {
    var label1: SKLabelNode = SKLabelNode()
    
    override func didMove(to view: SKView) {
        label1.text = "Test"
        label1.fontSize = 45
        self.addChild(label1)
    }

}
