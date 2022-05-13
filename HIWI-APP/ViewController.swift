//
//  ViewController.swift
//  HIWI-APP
//
//  Created by Tom Kolberg on 21.04.22.
//

import UIKit
import SceneKit
import Complex

class ViewController: UIViewController {
    
    //--Outlets
    @IBOutlet weak var sliderValueDisplay: UILabel!
    @IBOutlet weak var probSlider: UISlider!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var ProbText: UILabel!
    @IBOutlet weak var OutputText: UILabel!
    @IBOutlet weak var ParaGateControl: UISegmentedControl!
    
    
    //--Create Variables for Output
    var X = 1.0
    var Y = 0.0
    var Z1 = 0.0
    var Z2 = ""
    
    // create scene for the qubit visualization
    let scene = SCNScene()
    
    // create probability circle within bottom plate
    let probCircle = SCNNode()
    
    // create arrows within bottom plate and qubit
    let bottomArrow = SCNNode()
    let mainArrow = SCNNode()
    
    //--Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.layer.zPosition = -100

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x:0, y:-0.5, z: 6) // 6
        
        scene.rootNode.addChildNode(cameraNode)
        
        // Add Light to SCN Scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .ambient //-- Ambient
        lightNode.position = SCNVector3(x: 0, y: 10, z: 2)
        
        scene.rootNode.addChildNode(lightNode)
        
        
        //Create QubitBall
        // Add QubitBall to SCN Scene
        let qubitBall = QubitVisualization()
        qubitBall.position = SCNVector3(x:0 , y: 0, z:0)
        scene.rootNode.addChildNode(qubitBall)
        
        // add coordinate system within qubitBall
        let xAxis = SCNNode()
        xAxis.geometry = SCNBox(width: 4, height: 0.02, length: 0.02, chamferRadius: 0.0)
        xAxis.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        
        let yAxis = SCNNode()
        yAxis.geometry = SCNBox(width: 0.02, height: 4, length: 0.02, chamferRadius: 0.0)
        yAxis.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        
        let zAxis = SCNNode()
        zAxis.geometry = SCNBox(width: 0.02, height: 0.02, length: 4, chamferRadius: 0.0)
        zAxis.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        
        xAxis.position = SCNVector3(x:0, y:0, z:0)
        scene.rootNode.addChildNode(xAxis)
        zAxis.position = SCNVector3(x:0, y:0, z:0)
        scene.rootNode.addChildNode(zAxis)
        yAxis.position = SCNVector3(x:0, y:0, z:0)
        scene.rootNode.addChildNode(yAxis)
        
        
        // create border of QubitBall
        for i in 1...160 {
            let sphereNode = SCNNode(geometry: SCNSphere(radius:0.01))
            sphereNode.position = SCNVector3(0,0,0)
            sphereNode.simdPivot.columns.3.x = 2
            sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
            
            sphereNode.rotation = SCNVector4(0,1,0,(-CGFloat.pi * CGFloat(i))/80)
            scene.rootNode.addChildNode(sphereNode)
        }
        
        // create labeling of QubitBall
        let text1 = SCNText(string: "⏐0⟩", extrusionDepth: 0.9)
        text1.firstMaterial?.diffuse.contents = UIColor.black
        let node1 = SCNNode()
        node1.position = SCNVector3(x:-0.2, y:2.2, z:0)
        node1.scale = SCNVector3(x:0.02, y: 0.02 , z:0.02)
        node1.geometry = text1
        scene.rootNode.addChildNode(node1)
        
        let text2 = SCNText(string: "⏐1⟩", extrusionDepth: 0.9)
        text2.firstMaterial?.diffuse.contents = UIColor.black
        let node2 = SCNNode()
        node2.position = SCNVector3(x:-0.2, y:-2.3, z:0)
        node2.scale = SCNVector3(x:0.02, y: 0.02 , z:0.02)
        node2.geometry = text2
        scene.rootNode.addChildNode(node2)
        
        let text3 = SCNText(string: "X", extrusionDepth: 0.9)
        text3.firstMaterial?.diffuse.contents = UIColor.black
        let node3 = SCNNode()
        node3.position = SCNVector3(x:-2.4, y:0, z:0)
        node3.scale = SCNVector3(x:0.02, y: 0.02 , z:0.02)
        node3.geometry = text3
        scene.rootNode.addChildNode(node3)
        
        let text4 = SCNText(string: "⏐+⟩", extrusionDepth: 0.9)
        text4.firstMaterial?.diffuse.contents = UIColor.black
        let node4 = SCNNode()
        node4.position = SCNVector3(x:-2.5, y:-0.3, z:0)
        node4.scale = SCNVector3(x:0.02, y: 0.02 , z:0.02)
        node4.geometry = text4
        scene.rootNode.addChildNode(node4)
        
        let text5 = SCNText(string: "Y", extrusionDepth: 0.9)
        text5.firstMaterial?.diffuse.contents = UIColor.black
        let node5 = SCNNode()
        node5.position = SCNVector3(x:-0.1, y:-0.2, z:2.5)
        node5.scale = SCNVector3(x:0.02, y: 0.02 , z:0.02)
        node5.geometry = text5
        scene.rootNode.addChildNode(node5)
        
        let text6 = SCNText(string: "⏐-⟩", extrusionDepth: 0.9)
        text6.firstMaterial?.diffuse.contents = UIColor.black
        let node6 = SCNNode()
        node6.position = SCNVector3(x:2.2, y:0, z:0)
        node6.scale = SCNVector3(x:0.02, y: 0.02 , z:0.02)
        node6.geometry = text6
        scene.rootNode.addChildNode(node6)
        
        
        
        
        // CreateBottom Plate
        
        // Add Bottom Plate to SCN Scene
        let bottomPlate = BottomPlate()
        bottomPlate.position = SCNVector3(x:0, y: -2.5, z:0)
        scene.rootNode.addChildNode(bottomPlate)
        
        // Create border of Bottom Plate
        for i in 1...160 {
            let sphereNode = SCNNode(geometry: SCNSphere(radius:0.01))
            sphereNode.position = SCNVector3(0,-2.5,0)
            sphereNode.simdPivot.columns.3.x = 1.3
            sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
            
            sphereNode.rotation = SCNVector4(0,1,0,(-CGFloat.pi * CGFloat(i))/80)
            scene.rootNode.addChildNode(sphereNode)
        }
        
        // create bottom plate coordinates
        let line1 = SCNNode()
        line1.geometry = SCNBox(width:2.55, height: 0.02, length: 0.02, chamferRadius: 0.0)
        line1.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        
        let line2 = SCNNode()
        line2.geometry = SCNBox(width: 0.02, height: 0.02, length: 2.55, chamferRadius: 0.0)
        line2.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        
        line1.position = SCNVector3(x:0, y:-2.5, z:0)
        scene.rootNode.addChildNode(line1)
        line2.position = SCNVector3(x:0, y:-2.5, z:0)
        scene.rootNode.addChildNode(line2)
        
        // Create labeling of bootom plate
        let text7 = SCNText(string: "0", extrusionDepth: 0.9)
        text7.firstMaterial?.diffuse.contents = UIColor.black
        let node7 = SCNNode()
        node7.position = SCNVector3(x:-1.5, y:-2.6, z:0)
        node7.scale = SCNVector3(x:0.02, y: 0.02 , z:0.02)
        node7.geometry = text7
        scene.rootNode.addChildNode(node7)
        
        let text8 = SCNText(string: "π", extrusionDepth: 0.9)
        text8.firstMaterial?.diffuse.contents = UIColor.black
        let node8 = SCNNode()
        node8.position = SCNVector3(x:1.4, y:-2.6, z:0)
        node8.scale = SCNVector3(x:0.02, y: 0.02 , z:0.02)
        node8.geometry = text8
        scene.rootNode.addChildNode(node8)
        
        let text9 = SCNText(string: "π/2", extrusionDepth: 0.9)
        text9.firstMaterial?.diffuse.contents = UIColor.black
        let node9 = SCNNode()
        node9.position = SCNVector3(x:-0.2, y:-2.6, z:1.5)
        node9.scale = SCNVector3(x:0.02, y: 0.02 , z:0.02)
        node9.geometry = text9
        scene.rootNode.addChildNode(node9)
        
        let text10 = SCNText(string: "3π/2", extrusionDepth: 0.9)
        text10.firstMaterial?.diffuse.contents = UIColor.black
        let node10 = SCNNode()
        node10.position = SCNVector3(x:-0.2, y:-2.6, z:-1.5)
        node10.scale = SCNVector3(x:0.02, y: 0.02 , z:0.02)
        node10.geometry = text10
        scene.rootNode.addChildNode(node10)


        // create sceneView
        sceneView.scene = scene
        
        sceneView.backgroundColor = UIColor.white
        sceneView.allowsCameraControl = true
        
        // Slider transformation
        probSlider.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / -2))
        
        
        // Edit Output Text
        
        OutputText.text = "⎥𝜓⟩ =√" + X.description + " ⏐0⟩ + (√" + Y.description +  " )e^i" + Z1.description + "" + Z2 + "⏐1⟩"
        

    }
    
    
    @IBAction func pobSliderBar(_ sender: Any) {
        sliderValueDisplay.text = String(round(probSlider.value)/100)
    }
    
    /**
     Function that changes the Output if the 0-Button is clicked
     --> Works correctly
     */
    @IBAction func zeroClicked(_ sender: UIButton) {
        X = 1
        Y = 0
        Z1 = 0.0
        Z2 = ""
        changeOutput()
    }
    
    /**
     Function that changes the Output if the 1-Button is clicked
     --> Works correctly
     */
    @IBAction func oneButtonClicked(_ sender: UIButton) {
        X = 0
        Y = 1
        Z1 = 0.0
        Z2 = ""
        changeOutput()
    }
    
    
    /**
     Logic behind X Gate Button
     This button turns output value on X-axis around 180 degree
     */
    @IBAction func XGateButton(_ sender: UIButton) {
        let Xbuffer = X
        let Ybuffer = Y
        var xGate: [[Int]] = [[0 , 1],[1 , 0]]
        
        
        X = Ybuffer
        Y = Xbuffer
        changeOutput()
    }
    
    
    /**
     Logic behind Y Gate Button
     This button turns output value on Y-axis around 180 degree
     */
    @IBAction func YGateButton(_ sender: UIButton) {
        let Xbuffer = X
        let Ybuffer = Y
        var yGate: [[Int]] = [[0 ,],[1 , 0]]
        
        X = Ybuffer
        Y = Xbuffer
        changeOutput()
    }
    
    
    /**
     Logic behind Z Gate Button
     This button turns output value on Z-axis around 180 degree
     */
    @IBAction func ZGateButton(_ sender: UIButton) {
        if(Y > 0){
            if(Z1 > 0){
                Z1 = Z1+1
                Z2 = "π"
            } else{
                Z1 = Z1+1
                Z2 = "π"
            }
        }
        
        if(Z1 >= 2){
            Z1 = Z1-2
        }
        if(Z1 == 0){
            Z2 = ""
        }
        changeOutput()
    }
    
    @IBAction func HGateButton(_ sender: UIButton) {
        X = 0.5
        Y = 0.5
        
        changeOutput()
    }
    
    
    /**
     Logic behind S Gate Button
     This button turns output value on Z-axis around 90 degree
     */
    @IBAction func SGateButton(_ sender: UIButton) {
        if(Y > 0){
            if(Z1 > 0){
                Z1 = Z1+0.5
                Z2 = "π"
            } else{
                Z1 = Z1+0.5
                Z2 = "π"
            }
        }
        
        if(Z1 >= 2){
            Z1 = Z1-2
        }
        if(Z1 == 0){
            Z2 = ""
        }
        changeOutput()
    }
    
    @IBAction func SPlusGateButton(_ sender: UIButton) {
        if(Y > 0){
            if(Z1 > 0){
                Z1 = Z1-0.5
                Z2 = "π"
            } else{
                Z1 = Z1-0.5
                Z2 = "π"
            }
        }
        
        if(Z1 < 0){
            Z1 = Z1 + 2
        }
        if(Z1 == 0){
            Z2 = ""
        }

        changeOutput()
    }
    
    /**
     Logic behind T Gate Button
     This button turns output value on Z-axis around 45 degree
     */
    @IBAction func TGateButton(_ sender: UIButton) {
        
        if(Y > 0){
            if(Z1 > 0){
                Z1 = Z1+0.25
                Z2 = "π"
            } else{
                Z1 = Z1+0.25
                Z2 = "π"
            }
        }
        
        if(Z1 >= 2){
            Z1 = Z1-2
        }
        if(Z1 == 0){
            Z2 = ""
        }
        changeOutput()
    }
    
    @IBAction func TPlusGateButton(_ sender: UIButton) {
        if(Y > 0){
            if(Z1 > 0){
                Z1 = Z1-0.25
                Z2 = "π"
            } else{
                Z1 = Z1-0.25
                Z2 = "π"
            }
        }
        
        if(Z1 < 0 ){
            Z1 = Z1 + 2
        }
        if(Z1 == 0){
            Z2 = ""
        }
        changeOutput()
    }
    
    /**
     Write functions for parametrizable gates, which do the same as the 'normal' gates just for a predifined amount, that is defined in the SegmentContol Element: ParaGateControl
     */
    @IBAction func RXPlusButton(_ sender: UIButton) {
        print(ParaGateControl.selectedSegmentIndex)
    }
    @IBAction func RXMinusButton(_ sender: UIButton) {
    }
    @IBAction func RYPlusButton(_ sender: UIButton) {
    }
    @IBAction func RYMinusButton(_ sender: UIButton) {
    }
    @IBAction func RZPlusButton(_ sender: UIButton) {
        
        if(Y > 0){
            if(Z1 > 0){
                Z1 = Z1+1
                Z2 = "π"
            } else{
                Z1 = Z1+1
                Z2 = "π"
            }
        }
        
        if(Z1 >= 2){
            Z1 = Z1-2
        }
        if(Z1 == 0){
            Z2 = ""
        }
        changeOutput()
        if(ParaGateControl.selectedSegmentIndex == 0){
            
        }else{
            
        }
    }
    @IBAction func RZMinusButton(_ sender: UIButton) {
    }
    
    func changeOutput(){
        let Z1buffer = Z1
        if(Z1buffer == 1.0){
            OutputText.text = "⎥𝜓⟩ =√" + X.description + " ⏐0⟩ + (√" + Y.description +  " )e^i^" + Z2.description + "⏐1⟩"
        }
        else{
            OutputText.text = "⎥𝜓⟩ =√" + X.description + " ⏐0⟩ + (√" + Y.description +  " )e^i" + Z1buffer.description + Z2.description + "⏐1⟩"
        }

        
        probSlider.value = Float(X*100)
        sliderValueDisplay.text = String(X)
        changeBottomPlate()
        moveArrows()
    }
    
    /**
     Function, that changes the of the pobability plate within the bottom plate
     */
    func changeBottomPlate(){
        let radius = 1.3*X
        probCircle.geometry = SCNCylinder(radius: radius, height: 0.02)
        probCircle.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        probCircle.opacity = 0.5
        probCircle.position = SCNVector3(x:0, y: -2.49, z:0)
        self.scene.rootNode.addChildNode(probCircle)
    }
    
    /**
     Function that moves the arrows to the correct position if Gates are selected
     */
    func moveArrows(){
        // Bottom Array ist abhängig von dem Wert der hinter i Steht (Z2)
        
        bottomArrow.geometry = SCNBox(width: 1.5, height: 0.1, length: 0.1, chamferRadius: 0.0)
        bottomArrow.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        bottomArrow.position = SCNVector3(x:-0.8, y: -2.48, z:0)
        bottomArrow.rotation = SCNVector4Make(0, 180, 0, 1)
        
        // wird gemacht über y und w wert (2,4)
        // zusätzlich kann man die position anpassen um den Pfeilwieder in die Mitte zu Holen
        
        self.scene.rootNode.addChildNode(bottomArrow)
        
        
        // main Arrow ist abhänhih von dem Wert der gesamtn Gleichung
    }
    
    
    
    
}

