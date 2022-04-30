//
//  QubitVisualization.swift
//  HIWI-APP
//
//  Created by Tom Kolberg on 22.04.22.
//

import SceneKit

class QubitVisualization: SCNNode {

    override init() {
        super.init()
        self.geometry = SCNSphere(radius: 2)
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        self.opacity = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


