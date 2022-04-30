//
//  BottomPlate.swift
//  HIWI-APP
//
//  Created by Tom Kolberg on 22.04.22.
//

import SceneKit

class BottomPlate: SCNNode {

    override init() {
        super.init()
        self.geometry = SCNCylinder(radius: 1.3, height: 0.1)
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        self.opacity = 0.5
        //self.geometry?.firstMaterial?.fillMode = .lines
        //self.geometry?.firstMaterial?.isDoubleSided = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

