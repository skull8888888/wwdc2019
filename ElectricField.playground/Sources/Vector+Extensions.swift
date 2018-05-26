import SceneKit

public class Vector: SCNNode {
    
    lazy var cylinder: SCNCylinder = SCNCylinder(radius: 0.025, height: 0)
    lazy var cone: SCNCone = SCNCone(topRadius: 0, bottomRadius: 0.05, height: 0.15)
    
    lazy var coneNode: SCNNode = {
        
        cone.firstMaterial?.diffuse.contents = UIColor.Theme.vectorColor
        cone.radialSegmentCount = 12
        let node = SCNNode()
        node.geometry = cone
        
        self.addChildNode(node)
        
        return node
    }()
    
    lazy var cylinderNode: SCNNode = {
        
        cylinder.firstMaterial?.diffuse.contents = UIColor.Theme.vectorColor
        cylinder.radialSegmentCount = 12
        let node = SCNNode()
        node.geometry = cylinder
        
        self.addChildNode(node)
        
        return node
    }()
    
    
    public var direction: SCNVector3 = SCNVector3Zero {
        didSet {
            
            let l = sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z)
            
            let teta = acos(direction.y / l)
            
            var fi: Float = 0
            
            if direction.x > 0 && direction.z > 0 || direction.x < 0 && direction.z > 0 {
                fi = atan(direction.x / direction.z)
            } else if direction.x > 0 && direction.z == 0 {
                fi = Float.pi / 2
            } else if direction.x > 0 && direction.z < 0 || direction.x < 0 && direction.z < 0 {
                fi = atan(direction.x / direction.z) + Float.pi
            } else if direction.x == 0 && direction.z < 0 {
                fi = Float.pi
            } else if direction.x < 0 && direction.z == 0 {
                fi = -Float.pi / 2
            }
            
            self.cylinder.height = CGFloat(l)
            self.coneNode.position = SCNVector3(0,l + 0.075,0)
            self.cylinderNode.position = SCNVector3(0,l / 2,0)
            self.eulerAngles = SCNVector3(teta, fi, 0)
            
        }
    }
}

public extension SCNVector3 {
    
    public static func vector(_ a: SCNVector3, _ b: SCNVector3) -> SCNVector3{
        return SCNVector3(b.x - a.x, b.y - a.y, b.z - a.z)
    }
    
    public func length() -> Float{
        return sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
    }
    
    public func unit() -> SCNVector3{
        return SCNVector3(self.x / self.length(), self.y / self.length(), self.z / self.length())
    }
    
    public static func + (a: SCNVector3, b: SCNVector3) -> SCNVector3 {
        return SCNVector3(a.x + b.x, a.y + b.y, a.z + b.z)
    }

    public static func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }
 
    public func dot(_ v: SCNVector3) -> Float {
        return x * v.x + y * v.y + z * v.z
    }
    
    public func reversed() -> SCNVector3 {
        return SCNVector3(-self.x, -self.y, -self.z)
    }
    
    func isCloseTo(_ v: SCNVector3) -> Bool {
        return self.x.isCloseTo(v.x) && self.y.isCloseTo(v.y) && self.z.isCloseTo(v.z)
    }
  
}

public extension Float {
    
    func isCloseTo(_ n: Float) -> Bool {
        
        return abs(self - n) < 0.000001
    }

}

public extension SCNNode {
    
    func getPointsAroundVector(n: Int, radius: Float) -> [SCNVector3]{
        var points = [SCNVector3]()
        
        for i in 0..<n {
            let angle = Float(i) * 2 * Float.pi / Float(n)
            let z = cos(angle) * radius
            let x = sin(angle) * radius
            points.append(SCNVector3(x,0,z))
        }
        
        return points
    }
    
    func pointTowards(_ direction: SCNVector3){
        
        let l = direction.length()
    
        var teta = acos(direction.y / l)
        
        var fi: Float = Float(atan2(CGFloat(direction.x), CGFloat(direction.z)))
        
        if (Float.pi.isCloseTo(fi) || Float.pi.isCloseTo(-fi)) && direction.x.isCloseTo(0.0) {
            fi = 0.0
            teta *= -1
        }
        
        self.eulerAngles = SCNVector3(teta, fi, 0)
        
    }
    
}
