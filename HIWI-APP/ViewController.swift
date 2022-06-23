//
//  ViewController.swift
//  HIWI-APP
//
//  Created by Tom Kolberg on 21.04.22.
//

import UIKit
import SceneKit
import Complex
import iosMath

class ViewController: UIViewController {
    
    //--Outlets
    @IBOutlet weak var sliderValueDisplay: UILabel!
    @IBOutlet weak var probSlider: UISlider!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var ProbText: UILabel!
    @IBOutlet weak var ParaGateControl: UISegmentedControl!
    
    let output : MTMathUILabel = MTMathUILabel()

    
    //--Create Variables for Output
    var X = Complex(1,0)
    var Y = Complex(0,0)
    
    // create scene for the qubit visualization
    let scene = SCNScene()
    
    // create probability circle within bottom plate
    let probCircle = SCNNode()
    
    // create arrows within bottom plate and qubit
    let bottomArrow = SCNNode()
    let mainArrow = SCNNode()
    
    
    

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

        
        //create mainArrow and bottomArrow
        buildArrows()

        // create sceneView
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.white
        sceneView.allowsCameraControl = true
        
        // Slider transformation
        probSlider.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / -2))

        
        //Create Output equasion
        // Edit Output Text
        let text = " \\mid \\!\\! \\Psi \\!\\! > = \\sqrt{" + X.real.description + "} \\mid \\! 0 \\! > +  ( \\sqrt{" + Y.real.description + "}) e^{i^{0}} \\mid \\! 1 \\! >"
        output.latex = text
        view.addSubview(output)
        output.frame = CGRect(x: 20, y:100, width: 500 , height: 40)
        view.bringSubviewToFront(output)


    }

    /**
     Method, that transforms shows the Slidervalue text  above the SliderBar
     */
    @IBAction func pobSliderBar(_ sender: Any) {
        sliderValueDisplay.text = String(round(probSlider.value)/100)
    }
    
    
    /**
     Function that changes the Output if the 0-Button is clicked
     */
    @IBAction func zeroClicked(_ sender: UIButton) {
        X = Complex(1,0)
        Y = Complex(0,0)

        changeOutput()
    }
    
    /**
     Function that changes the Output if the 1-Button is clicked
     --> Works correctly
     */
    @IBAction func oneButtonClicked(_ sender: UIButton) {
        X = Complex(0,0)
        Y = Complex(1,0)
        
        changeOutput()
    }
    
    
    /**
     Logic behind X Gate Button
     This button turns output value on X-axis around 180 degree
     */
    @IBAction func XGateButton(_ sender: UIButton) {

        let Xbuffer = 0.0 * X + 1.0 * Y
        let Ybuffer = 1.0 * X + 0.0 * Y

        X = Xbuffer
        Y = Ybuffer
        changeOutput()
    }
    
    
    /**
     Logic behind Y Gate Button
     
     ArrayShape:    (0 ,                      Complex(0,-1))
                (Complex(0,1) ,   0                    )
     */
    @IBAction func YGateButton(_ sender: UIButton) {
        
        let complex1 = Complex(0,-1)
        let complex2 = Complex(0,1)
        
        let Xbuffer = X * 0 + Y * complex2
        let Ybuffer = X * complex1 + Y * 0
        
        X = Xbuffer
        Y = Ybuffer

        changeOutput()
    }
    
    
    /**
     Logic behind Z Gate Button
     This button turns output value on Z-axis around 180 degree
     */
    @IBAction func ZGateButton(_ sender: UIButton) {
        let zGate = [[1.0 , 0.0],[0.0 , -1.0]]
        let Xbuffer = X * zGate[0][0] + Y * zGate[1][0]
        let Ybuffer = X * zGate[0][1] + Y * zGate[1][1]
        
        X = Xbuffer
        Y = Ybuffer
        
        changeOutput()
    }
    
    /**
     Logic behind Hardamard Gate Button
     */
    @IBAction func HGateButton(_ sender: UIButton) {
        
        let hGate = [[1/sqrt(2) ,1/sqrt(2)],[1/sqrt(2) , -1/sqrt(2)]]
        let Xbuffer = X * hGate[0][0] + Y * hGate[1][0]
        let Ybuffer = X * hGate[0][1] + Y * hGate[1][1]
        
        X = Xbuffer
        Y = Ybuffer
        changeOutput()
    }
    
    
    /**
     Logic behind S Gate Button
     This button turns output value on Z-axis around 90 degree
     
     ArrayShape:    (1 ,  0                   )
                (0, Complex(0,1))
     */
    @IBAction func SGateButton(_ sender: UIButton) {
        let complex1 = Complex(0,1)
        let Xbuffer = X * 1 + Y * 0
        let Ybuffer = X * 0 + Y * complex1
        
        X = Xbuffer
        Y = Ybuffer

        changeOutput()
    }
    
    /**
     Logic behind S Gate Button
     This button turns output value on Z-axis around 90 degree
     
     ArrayShape:    (1 ,  0                   )
                ( 0, Complex(0,-1))
     */
    @IBAction func SPlusGateButton(_ sender: UIButton) {
        let complex1 = Complex(0,-1)
        let Xbuffer = X * 1 + Y * 0
        let Ybuffer = X * 0 + Y * complex1

        X = Xbuffer
        Y = Ybuffer
        
        changeOutput()
    }
    
    /**
     Logic behind T Gate Button
     This button turns output value on Z-axis around 45 degree
     */
    @IBAction func TGateButton(_ sender: UIButton) {
        let complex1 = Complex(1/sqrt(2),1/sqrt(2))
        let Xbuffer = X * 1 + Y * 0
        let Ybuffer = X * 0 + Y * complex1

        X = Xbuffer
        Y = Ybuffer
        changeOutput()
    }
    
    /**
     Logic behind T Gate Button
     This button turns output value on Z-axis around - 45 degree
     */
    @IBAction func TPlusGateButton(_ sender: UIButton) {
        let complex1 = Complex(1/sqrt(2),-1/sqrt(2))
        let Xbuffer = X * 1 + Y * 0
        let Ybuffer = X * 0 + Y * complex1
        
        X = Xbuffer
        Y = Ybuffer
        changeOutput()
    }
    
    /**
     Logic Behind parametrizable X-Plus Gate, which is dependent on the selected value of the slider
     */
    @IBAction func RXPlusButton(_ sender: UIButton) {
        
        if(ParaGateControl.selectedSegmentIndex == 0){     // pi/8
            let complex1 = Complex(0,-sin(Double.pi/16))
            let Xbuffer = X * cos(Double.pi / 16) + Y * complex1
            let Ybuffer = X * complex1 + Y * cos(Double.pi / 16)
            
            X = Xbuffer
            Y = Ybuffer
        }else{                                             //pi/12
            let complex1 = Complex(0,-sin(Double.pi/24))
            let Xbuffer = X * cos(Double.pi / 24) + Y * complex1
            let Ybuffer = X * complex1 + Y * cos(Double.pi / 24)
            
            X = Xbuffer
            Y = Ybuffer
        }

        changeOutput()
    }
    
    /**
     Logic Behind parametrizable X -Minus Gate, which is dependent on the selected value of the slider
     */
    @IBAction func RXMinusButton(_ sender: UIButton) {
        if(ParaGateControl.selectedSegmentIndex == 0){  // pi/8
            let complex1 = Complex(0,-sin(-Double.pi/16))
            let Xbuffer = X * cos(-Double.pi / 16) + Y * complex1
            let Ybuffer = X * complex1 + Y * cos(-Double.pi / 16)
            
            X = Xbuffer
            Y = Ybuffer
            
        } else {                                        //pi/12
            let complex1 = Complex(0,-sin(-Double.pi/24))
            let Xbuffer = X * cos(-Double.pi / 24) + Y * complex1
            let Ybuffer = X * complex1 + Y * cos(-Double.pi / 24)
            
            X = Xbuffer
            Y = Ybuffer
        }
        
        changeOutput()
    }
    
    /**
     Logic Behind parametrizable Y-Plus Gate, which is dependent on the selected value of the slider
     */
    @IBAction func RYPlusButton(_ sender: UIButton) {
        if(ParaGateControl.selectedSegmentIndex == 0){  // pi/8
            let Xbuffer = X * cos(Double.pi / 16) + Y * sin(Double.pi / 16)
            let Ybuffer = X * -sin(Double.pi / 16) + Y * cos(Double.pi / 16)
            
            X = Xbuffer
            Y = Ybuffer
            
        } else {                                        //pi/12
            let Xbuffer = X * cos(Double.pi / 24) + Y * sin(Double.pi / 24)
            let Ybuffer = X * -sin(Double.pi / 24) + Y * cos(Double.pi / 24)
            
            X = Xbuffer
            Y = Ybuffer
        }
        changeOutput()
    }
    
    /**
     Logic Behind parametrizable Y-Minus Gate, which is dependent on the selected value of the slider
     */
    @IBAction func RYMinusButton(_ sender: UIButton) {
        if(ParaGateControl.selectedSegmentIndex == 0){  // pi/8
            let Xbuffer = X * cos(-Double.pi / 16) + Y * sin(-Double.pi / 16)
            let Ybuffer = X * -sin(-Double.pi / 16) + Y * cos(-Double.pi / 16)
            
            X = Xbuffer
            Y = Ybuffer
            
        } else {                                        //pi/12
            let Xbuffer = X * cos(-Double.pi / 24) + Y * sin(-Double.pi / 24)
            let Ybuffer = X * -sin(-Double.pi / 24) + Y * cos(-Double.pi / 24)
            
            X = Xbuffer
            Y = Ybuffer
        }
        changeOutput()
    }
    
    
    
    
    /**
     Logic Behind parametrizable Z-Plus Gate, which is dependent on the selected value of the slider
     */
    @IBAction func RZPlusButton(_ sender: UIButton) {

        if(ParaGateControl.selectedSegmentIndex == 0){  // pi/8

            let val1 = Complex(0.0, -1.0) * (Double.pi / 16)
            let val2 = Complex(0.0, 1.0) * (Double.pi / 16)
            let res1 = Complex.exp(val1)
            let res2 = Complex.exp(val2)
            let Xbuffer = X * res1 + Y * 0.0
            let Ybuffer = X * 0.0 + Y * res2
            
            X = Xbuffer
            Y = Ybuffer
        } else { //pi/12
            let val1 = Complex(0.0, -1.0) * (Double.pi / 24)
            let val2 = Complex(0.0, 1.0) * (Double.pi / 24)
            let res1 = Complex.exp(val1)
            let res2 = Complex.exp(val2)
            let Xbuffer = X * res1 + Y * 0.0
            let Ybuffer = X * 0.0 + Y * res2
            
            X = Xbuffer
            Y = Ybuffer
        }
        changeOutput()
    }
    
    /**
     Logic Behind parametrizable Z-Minus Gate, which is dependent on the selected value of the slider
     */
    @IBAction func RZMinusButton(_ sender: UIButton) {
        
        if(ParaGateControl.selectedSegmentIndex == 0){  // pi/8

            let val1 = Complex(0.0, -1.0) * (-Double.pi / 16)
            let val2 = Complex(0.0, 1.0) * (-Double.pi / 16)
            let res1 = Complex.exp(val1)
            let res2 = Complex.exp(val2)
            let Xbuffer = X * res1 + Y * 0.0
            let Ybuffer = X * 0.0 + Y * res2
            
            X = Xbuffer
            Y = Ybuffer
        } else { //pi/12
            let val1 = Complex(0.0, -1.0) * (-Double.pi / 24)
            let val2 = Complex(0.0, 1.0) * (-Double.pi / 24)
            let res1 = Complex.exp(val1)
            let res2 = Complex.exp(val2)
            let Xbuffer = X * res1 + Y * 0.0
            let Ybuffer = X * 0.0 + Y * res2
            
            X = Xbuffer
            Y = Ybuffer
        }
        changeOutput()
    }
    
    
    
    
    
    
    
    func changeOutput(){
        
        // Round Output
        let ZeroOutput = round((X.real * X.real + X.imag * X.imag ) * 100)/100
        let OneOutput = round((Y.real * Y.real + Y.imag * Y.imag ) * 100)/100
        let azimRads = round(calcAzimRads()*100)/100
        
    
        // Create Output
        if(azimRads > 0){
            let text = " \\mid \\!\\! \\Psi \\!\\! > = \\sqrt{" + ZeroOutput.description + "} \\mid \\! 0 \\! > +  ( \\sqrt{" + OneOutput.description + "}) e^{i^{" + azimRads.description + "\\pi }} \\mid \\! 1 \\! >"
            output.latex = text
        }
        else{
            let text = " \\mid \\!\\! \\Psi \\!\\! > = \\sqrt{" + ZeroOutput.description + "} \\mid \\! 0 \\! > +  ( \\sqrt{" + OneOutput.description + "}) e^{i^{" + azimRads.description + "}} \\mid \\! 1 \\! >"
            output.latex = text
        }

        probSlider.value = Float(ZeroOutput*100)
        sliderValueDisplay.text = String(ZeroOutput)
        changeBottomPlate()
        moveArrows()
        

        
    }
    
    func calcAzimRads() -> Double{
        var Xresult = 0.0
        var Yresult = 0.0

        // Calculate Polar Value for X
        if(X.real > 0 && X.imag > 0){
            Xresult = atan(abs(X.real)/abs(X.imag))
        }
        if(X.real > 0 && X.imag < 0){
            Xresult = (-1) * atan(abs(X.real)/abs(X.imag))
        }
        if(X.real < 0 && X.imag < 0){
            Xresult =  atan(abs(X.real)/abs(X.imag)) - Double.pi
        }
        if(X.real < 0 && X.imag > 0){
            Xresult =  Double.pi - atan(abs(X.real)/abs(X.imag))
        }
        if(X.real == 0){
            if(X.imag > 0){
                Xresult = -Double.pi / 2
            }
            if(X.imag < 0){
                Xresult = Double.pi / 2
            }
        }
        
        if(X.imag == 0){
            Xresult = 0
        }
        
        // Calculate Polar Value for Y
        if(Y.real > 0 && Y.imag > 0){
            Yresult = atan(abs(Y.real)/abs(Y.imag))
        }
        if(Y.real > 0 && Y.imag < 0){
            Yresult = (-1) * atan(abs(Y.real)/abs(Y.imag))
        }
        if(Y.real < 0 && Y.imag < 0){
            Yresult =  atan(abs(Y.real)/abs(Y.imag)) - Double.pi
        }
        if(Y.real < 0 && Y.imag > 0){
            Yresult =  Double.pi - atan(abs(Y.real)/abs(Y.imag))
        }
        if(Y.real == 0){
            if(Y.imag > 0){
                Yresult = -Double.pi / 2
            }
            if(Y.imag < 0){
                Yresult = Double.pi / 2
            }
        }
        
        if(Y.imag == 0){
            Yresult = 0
        }
        
        var result = Yresult - Xresult
        
        if (result < 0){
            result = 2 * Double.pi - result
        }
         
        // calculates modulo, if result > 2 pi
        if(result > (2 * Double.pi)){
            result = result.truncatingRemainder(dividingBy: (Double.pi * 2))
        }
        
        return result

    }
    
    /**
     Function, that changes the of the pobability plate within the bottom plate
     */
    func changeBottomPlate(){
        let radius = 1.3 * sqrt(X.real * X.real + X.imag * X.imag)
        probCircle.geometry = SCNCylinder(radius: radius, height: 0.02)
        probCircle.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        probCircle.opacity = 0.5
        probCircle.position = SCNVector3(x:0, y: -2.49, z:0)
        self.scene.rootNode.addChildNode(probCircle)
    }
    
    /**
     Function that moves the arrows to the correct position if Gates were selected
     */
    func moveArrows(){

        //move arrow of bottom plate
        bottomArrow.rotation = SCNVector4Make(0, 1, 0, Float(calcAzimRads())) // Rotates the Arrow
        
        //TODO: Add correct rotation of main Arrow
        //move arrow in main qbit
        //mainArrow.rotation = SCNVector4Make(0, 0, 1, Float(calcAzimRads())) // Rotates the Arrow

    }

    
    /**
     Method that builds the arrows within the scene
     */
    func buildArrows(){
        //Create Arrow:
        //(Source: https://stackoverflow.com/questions/47191068/how-to-draw-an-arrow-in-scenekit)
        
        let vertcount = 48;
        let verts: [Float] = [ -1.4923, 1.1824, 2.5000, -6.4923, 0.000, 0.000, -1.4923, -1.1824, 2.5000, 4.6077, -0.5812, 1.6800, 4.6077, -0.5812, -1.6800, 4.6077, 0.5812, -1.6800, 4.6077, 0.5812, 1.6800, -1.4923, -1.1824, -2.5000, -1.4923, 1.1824, -2.5000, -1.4923, 0.4974, -0.9969, -1.4923, 0.4974, 0.9969, -1.4923, -0.4974, 0.9969, -1.4923, -0.4974, -0.9969 ];

        let facecount = 13;
        let faces: [CInt] = [  3, 4, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 0, 1, 2, 3, 4, 5, 6, 7, 1, 8, 8, 1, 0, 2, 1, 7, 9, 8, 0, 10, 10, 0, 2, 11, 11, 2, 7, 12, 12, 7, 8, 9, 9, 5, 4, 12, 10, 6, 5, 9, 11, 3, 6, 10, 12, 4, 3, 11 ];

        let vertsData  = NSData(
            bytes: verts,
            length: MemoryLayout<Float>.size * vertcount
        )

        let vertexSource = SCNGeometrySource(data: vertsData as Data,
                                            semantic: .vertex,
                                            vectorCount: vertcount,
                                            usesFloatComponents: true,
                                            componentsPerVector: 3,
                                            bytesPerComponent: MemoryLayout<Float>.size,
                                            dataOffset: 0,
                                            dataStride: MemoryLayout<Float>.size * 3)

        let polyIndexCount = 61;
        let indexPolyData  = NSData( bytes: faces, length: MemoryLayout<CInt>.size * polyIndexCount )

        let element1 = SCNGeometryElement(data: indexPolyData as Data,
                                        primitiveType: .polygon,
                                        primitiveCount: facecount,
                                        bytesPerIndex: MemoryLayout<CInt>.size)

        let geometry1 = SCNGeometry(sources: [vertexSource], elements: [element1])

        let material1 = geometry1.firstMaterial!

        material1.diffuse.contents = UIColor.blue
        
        
        //Build mainArrow:
        mainArrow.geometry = geometry1
        mainArrow.scale = SCNVector3(0.3, 0.1, 0.05) // change size of Arrow
        mainArrow.position = SCNVector3(x:0, y: 0, z:0)
        mainArrow.rotation = SCNVector4Make(0, 0, 1, Float(-Double.pi/2)) // Rotates the Arrow
        self.scene.rootNode.addChildNode(mainArrow)
        
        // Build bottomArrow
        let geometry2 = SCNGeometry(sources: [vertexSource], elements: [element1])
        let material2 = geometry2.firstMaterial!
        material2.diffuse.contents = UIColor.red // change color of bottomArrow
        
        bottomArrow.geometry = geometry2
        bottomArrow.scale = SCNVector3(0.2, 0.05, 0.05) // change size of Arrow
        bottomArrow.position = SCNVector3(x:0, y: -2.5, z:0)
        self.scene.rootNode.addChildNode(bottomArrow)
    }
}

