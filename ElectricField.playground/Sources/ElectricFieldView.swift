import SceneKit

open class ElectricFieldView: SCNView {
    
    lazy public var E = ElectricField()
    
    public override init(frame: CGRect, options: [String: Any]? = nil) {
        super.init(frame: frame, options: options)
        
        let scene = SCNScene()
        self.backgroundColor = .black
        self.allowsCameraControl = true
        
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.position = SCNVector3(0,10,0)
        lightNode.light = light
        lightNode.light?.castsShadow = true
        scene.rootNode.addChildNode(lightNode)
        
        let light1 = SCNLight()
        light1.type = .ambient
        light1.intensity = 200
        let lightNode1 = SCNNode()
        lightNode1.light = light1
        scene.rootNode.addChildNode(lightNode1)
        
        scene.rootNode.addChildNode(E)
        
        self.scene = scene
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

