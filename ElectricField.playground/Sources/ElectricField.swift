import SceneKit
import SpriteKit

struct ColorFragment {
    var vectorNode: SCNNode
    var cylinderNode: SCNNode
    var lightNode: SCNNode
    var heavyNode: SCNNode
}

protocol ElectricFieldDelegate: AnyObject {
    func electricField(_ E: ElectricField, didAddChargedNode chargedNode: ChargedNode)
}

public class ElectricField: SCNNode {
    
    weak var delegate: ElectricFieldDelegate?
    
    lazy var charges = [SCNVector4]()
    lazy var lineStartingPoints = [SCNVector4]()
    
    var colorFragments: [Float: ColorFragment] = [:]
    
    let vectorNodeStandardLength: CGFloat = 0.2
    let cylinderNodeStandardLength: CGFloat = 0.05
    
    public override init() {
        super.init()
        
        for i in 0...10 {
            
            let key = Float(i) / 10.0
            
            if let color = UIColor.colorFromFloat(start: UIColor.Theme.startColor, end: UIColor.Theme.endColor, f: CGFloat(key)) {
                
                let vectorNode = SCNVector3.vectorNode(color, length: vectorNodeStandardLength)
                let cylinderNode = SCNVector3.cylinderNode(color, length: cylinderNodeStandardLength)

                let parentNode = SCNNode()
                self.addChildNode(parentNode)

                let colorFragment = ColorFragment(vectorNode: vectorNode, cylinderNode: cylinderNode, lightNode: parentNode, heavyNode: SCNNode())

                self.colorFragments[key] = colorFragment
            }
            
        }
    
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    public func add(_ node: ChargedNode){
    
        let chargedNodes = self.childNodes.filter { $0 is ChargedNode }
        
        guard chargedNodes.count < 10 else { return }
        
        if let charges = node.charges {
            for q in charges {
                let p = node.convertPosition(SCNVector3(q.x, q.y, q.z), to: self)
                self.charges.append(SCNVector4(p.x, p.y, p.z, q.w))
            }
        }

        if let startingPoints = node.fieldLinesStartingPoints {

            for p in startingPoints {
                let convertedPoint = node.convertPosition(SCNVector3(p.x, p.y, p.z), to: self)
                self.lineStartingPoints.append(SCNVector4(convertedPoint.x, convertedPoint.y, convertedPoint.z, node.charge))
            }
        }
        
        self.addChildNode(node)
        
        delegate?.electricField(self, didAddChargedNode: node)

    }
    
    public func drawVectorField(n: Int){
        
        for x in (-n)...n {
            for y in (-n)...n {
                for z in (-n)...n {
                   
                    let point = SCNVector3(x,y,z)
                    let E = electricField(at: point)
                    
                    if !E.x.isNaN || !E.y.isNaN || !E.z.isNaN {
                        
                        let x = E.length()
                        
                        let p = x / (1 + abs(x))
                        let key = round(p * 10) / 10
                        
                        if let colorFragment = colorFragments[key] {
                        
                            let v = colorFragment.vectorNode.clone()
                            
                            v.position = point
                            v.pointTowards(E)
                            
                            colorFragment.heavyNode.addChildNode(v)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        updateColorFragments()
        
    }
    
    public func drawFieldLines(segmentCount: Int = 40){
        
        for p in self.lineStartingPoints {
            
            var currentPoint = SCNVector3(p.x, p.y, p.z)
            
            inner: for _ in 0...segmentCount {
                
                let E = self.electricField(at: currentPoint)
                
                let step = Float(cylinderNodeStandardLength)
                let deltaVector = p.w < 0 ? E.unit() * (step * -1) : E.unit() * step
                
                let x = E.length()
                let p = x / (1 + abs(x))
                let key = round(p * 10) / 10

                if let colorFragment = colorFragments[key] {
                    
                    let cylinderNode = colorFragment.cylinderNode.clone()
                    
                    cylinderNode.position = currentPoint + (deltaVector * 0.5)
                    cylinderNode.pointTowards(E)
                    colorFragment.heavyNode.addChildNode(cylinderNode)
                    
                }
            
                currentPoint = currentPoint + deltaVector
                
                if isCloseToCharges(currentPoint, range: 0.1) {
                    break inner
                }
                
            }
            
        }
        
        updateColorFragments()
        
    }
    
}

// Electric Field
extension ElectricField {
    
    func electricField(at point: SCNVector3) -> SCNVector3 {

        var vectorSum = SCNVector3Zero
        
        // coefficient used in vector field formula
        // here precise value doesn't really matter
        //
        let K: Float = 10//9 * pow(10, 9)
        
        for q in self.charges {
            
            //position vector from charge 'q' to the point
            let R = SCNVector3.vector(SCNVector3(q.x, q.y, q.z), point)
            // thus distance from the charge 'q' to the point
            let r = R.length()
            
            if !r.isCloseTo(0) {
                
                // field at that point due to the charge 'q' (scalar component)
                let E = R.unit() * (K * q.w / (r * r))

                vectorSum = vectorSum + E
                
            }
            
        }
        
        return vectorSum
        
    }
    
}

//Update Inner Contents
extension ElectricField {
    
    func updateColorFragments(){
        
        for i in 0...10 {
            
            let key = Float(i) / 10.0
            
            if let colorFragment = colorFragments[key] {
                
                let optimizedNode = colorFragment.heavyNode.flattenedClone()
                
                colorFragment.lightNode.geometry = optimizedNode.geometry
                
                colorFragment.heavyNode.childNodes.forEach {$0.removeFromParentNode()}
                
            }
            
        }
        
    }
    
    func updateChargesPosition(){
        
        self.charges.removeAll()
        self.lineStartingPoints.removeAll()
        
        if let chargedNodes = self.childNodes.filter({ (node) -> Bool in
            return node is ChargedNode
        }) as? [ChargedNode] {
            
            for chargedNode in chargedNodes {
                
                for q in chargedNode.charges {
                    
                    let p = chargedNode.convertPosition(SCNVector3(q.x, q.y, q.z), to: self)
                    self.charges.append(SCNVector4(p.x, p.y, p.z, q.w))
                    
                }
                
                for p in chargedNode.fieldLinesStartingPoints {
                    let convertedPoint = chargedNode.convertPosition(SCNVector3(p.x, p.y, p.z), to: self)
                    self.lineStartingPoints.append(SCNVector4(convertedPoint.x, convertedPoint.y, convertedPoint.z, chargedNode.charge))
                }
                
            }
            
        }
        
    }
    
}


//Utils
extension ElectricField {
    
    func isCloseToCharges(_ point: SCNVector3, range: Float = 1.0) -> Bool {
        
        for q in self.charges {
            
            let qPosition = SCNVector3(q.x, q.y, q.z)
            
            let diff = (point - qPosition).length()

            if diff <= range {
                return true
            }
            
        }
        
        return false
        
    }
    
}
