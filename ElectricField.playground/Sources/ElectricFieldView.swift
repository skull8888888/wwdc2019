import SceneKit
import UIKit

open class ElectricFieldView: SCNView {
    
    lazy public var E = ElectricField()
    
    var movingNode: ChargedNode!
    var selectedNode: ChargedNode!
    var ghostNode: ChargedNode!
    
    var i = 0
    
    enum VisualizationType: Int {
        case vectorField, fieldLines
    }
    
    var visualizationType: VisualizationType = .vectorField
    
    public var vectorFieldCount = 5
    public var segmentCount = 80

    var panel: PanelView!
    var configView: ChargedNodeConfigView!
    
    var firstTimeRun = true
    
    public override init(frame: CGRect, options: [String: Any]? = nil) {
        super.init(frame: frame, options: options)
        
        let scene = SCNScene()
        self.backgroundColor = .black
        self.allowsCameraControl = true
        self.showsStatistics = true
        self.autoenablesDefaultLighting = true
    
        E.delegate = self
        scene.rootNode.addChildNode(E)
        
        self.scene = scene
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognizerHandler))
        self.addGestureRecognizer(longPressGestureRecognizer)

        
        let tapPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerHandler))
        self.addGestureRecognizer(tapPressGestureRecognizer)

        
        self.panel = PanelView(frame: .zero)
        panel.EFView = self
        self.addSubview(panel)

        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true

        configView = ChargedNodeConfigView(frame: .zero)
        configView.EFView = self
        self.addSubview(configView)
        
        configView.translatesAutoresizingMaskIntoConstraints = false
        configView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        configView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        configView.isHidden = true
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        guard firstTimeRun else { return }
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0,0,20)
        self.pointOfView = cameraNode

        self.firstTimeRun = false
        
    }
    
    @objc func tapGestureRecognizerHandler(gesture: UITapGestureRecognizer) {
        
        let point = gesture.location(in: self)
        
        if let node = self.chargedNode(at: point) {
        
            guard node != self.selectedNode else { return }
            
            self.selectedNode = node
            self.configView.selectedNode = node
            
            configView.isHidden = false

        } else {
            
            self.selectedNode = nil
            
            self.configView.selectedNode = nil

            configView.isHidden = true
            
        }
        
    }
    
    @objc func longPressGestureRecognizerHandler(gesture: UILongPressGestureRecognizer){
        
        switch gesture.state {
        case .began:
            
            let point = gesture.location(in: self)
            
            if let node = self.chargedNode(at: point) {
                
                if visualizationType == .fieldLines {
                    
                    self.ghostNode = node.clone()
                    self.ghostNode.opacity = 0.5
                    self.scene?.rootNode.addChildNode(ghostNode)
                    
                    self.selectedNode = node
                    movingNode = ghostNode

                    
                } else {
                    movingNode = node
                }
                
            }
        
        case .changed:
            
            if movingNode == nil { break }
            
            let point = gesture.location(in: self)
            
            let projectedPoint = self.projectPoint(movingNode.position)
            
            let unprojectedPoint = self.unprojectPoint(SCNVector3(point.x, point.y, CGFloat(projectedPoint.z)))
            
            movingNode.position = unprojectedPoint

            i += 1
            
            if i % 3 == 0 {
                
                if self.visualizationType == .vectorField {
                    self.visualize()
                }
                
            }
        
        case .ended:
            
            if visualizationType == .fieldLines {
                
                self.selectedNode.position = self.ghostNode.position
                self.selectedNode.transform = self.ghostNode.transform
                
                self.ghostNode?.removeFromParentNode()
                self.ghostNode = nil
                
                self.selectedNode = nil
            }
            
            self.movingNode = nil
            self.visualize()
            
            i = 0
            
        default: break
            
        }
        
    }
    
}



extension ElectricFieldView {
    
    public func visualize(){
    
        E.updateChargesPosition()
        
        switch self.visualizationType {
        case .fieldLines: E.drawFieldLines(segmentCount: self.segmentCount)
        case .vectorField: E.drawVectorField(n: self.vectorFieldCount)
        }
        
    }
    
}

extension ElectricFieldView {
    
    func chargedNode(at point: CGPoint) -> ChargedNode? {
        
        let results = self.hitTest(point, options: nil)
        return results.first { $0.node is ChargedNode && $0.node != self.ghostNode }?.node as? ChargedNode
        
    }
    
}

extension ElectricFieldView: ElectricFieldDelegate {
    
    func electricField(_ E: ElectricField, didAddChargedNode chargedNode: ChargedNode) {
        self.visualize()
    }
    
}
