//
//  ViewController.swift
//  HIWI-APP
//
//  Created by Tom Kolberg on 21.04.22.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    
    //--Outlets
    @IBOutlet weak var sliderValueDisplay: UILabel!
    @IBOutlet weak var probSlider: UISlider!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var ProbText: UILabel!
    @IBOutlet weak var OutputText: UILabel!
    
    //--Create Variables for Output
    var X = 1.0
    var Y = 0.0
    var Z = 0.0
    
    //--Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        sceneView.layer.zPosition = -100

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x:0, y:-0.5, z: 6) // 2.7
        
        scene.rootNode.addChildNode(cameraNode)
        
        // Add Light to SCN Scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .ambient //-- Ambient
        lightNode.position = SCNVector3(x: 0, y: 10, z: 2)
        
        scene.rootNode.addChildNode(lightNode)
        
        // Add QubitBall to SCN Scene
        let qubitBall = QubitVisualization()
        qubitBall.position = SCNVector3(x:0 , y: 0, z:0)
        scene.rootNode.addChildNode(qubitBall)
        
        // Add Bottom Plate to SCN Scene
        let bottomPlate = BottomPlate()
        bottomPlate.position = SCNVector3(x:0, y: -2.2, z:0)
        scene.rootNode.addChildNode(bottomPlate)
        
        // Add Labels to SCN Scene
        
        
        // --let sceneView = self.view as! SCNView
        sceneView.scene = scene
        
        //sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.white
        sceneView.allowsCameraControl = true
        
        // Slider transformation
        probSlider.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / -2))
        
        
        // Edit Output Text
        
        OutputText.text = "⎥𝜓⟩ =√" + X.description + " ⏐0⟩ + (√" + Y.description +  " )e^i" + Z.description + "⏐1⟩"

    }
    
    @IBAction func pobSliderBar(_ sender: Any) {
        sliderValueDisplay.text = String(round(probSlider.value)/100)
    }
    @IBAction func zeroClicked(_ sender: UIButton) {
        X = 1
        Y = 0
        changeOutput()

    }
    
    @IBAction func oneButtonClicked(_ sender: UIButton) {
        X = 0
        Y = 1
        changeOutput()
    }
    
    @IBAction func XGateButton(_ sender: UIButton) {
        
        let Xbuffer = X
        let Ybuffer = Y
        X = Ybuffer
        Y = Xbuffer
        changeOutput()
    }
    
    @IBAction func YGateButton(_ sender: UIButton) {
        let Xbuffer = X
        let Ybuffer = Y
        X = Ybuffer
        Y = Xbuffer
        changeOutput()
    }
    @IBAction func ZGateButton(_ sender: UIButton) {
    }
    
    @IBAction func HGateButton(_ sender: UIButton) {
        X = 0.5
        Y = 0.5
        
        changeOutput()
    }
    
    @IBAction func SGateButton(_ sender: UIButton) {
    }
    
    @IBAction func SPlusGateButton(_ sender: UIButton) {
    }
    
    @IBAction func TGateButton(_ sender: UIButton) {
    }
    
    @IBAction func TPlusGateButton(_ sender: UIButton) {
    }
    
    func changeOutput(){
        OutputText.text = "⎥𝜓⟩ =√" + X.description + " ⏐0⟩ + (√" + Y.description +  " )e^i" + Z.description + "⏐1⟩"
        
        probSlider.value = Float(X*100)
        sliderValueDisplay.text = String(X)
    }
    
    
    
    
}

