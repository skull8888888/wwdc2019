import SceneKit

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
    
    public static func - (a: SCNVector3, b: SCNVector3) -> SCNVector3 {
        return a + b.reversed()
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
    
    public static func vectorNode(_ color: UIColor, length: CGFloat = 0.2) -> SCNNode {
        
        let parentNode = SCNNode()
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        
        let cone: SCNCone = SCNCone(topRadius: 0, bottomRadius: 0.05, height: 0.15)
        cone.radialSegmentCount = 3
        cone.firstMaterial = material
        let coneNode = SCNNode()
        coneNode.geometry = cone
        coneNode.position = SCNVector3(0, length + 0.075, 0)
        parentNode.addChildNode(coneNode)
        
        let cylinder: SCNCylinder = SCNCylinder(radius: 0.025, height: length)
        cylinder.radialSegmentCount = 3
        cylinder.firstMaterial = material
        let cylinderNode = SCNNode()
        cylinderNode.geometry = cylinder
        cylinderNode.position = SCNVector3(0, length / 2, 0)
        parentNode.addChildNode(cylinderNode)
       
        return parentNode.flattenedClone()
        
    }
    
    public static func cylinderNode(_ color: UIColor, length: CGFloat = 0.2) -> SCNNode {

        let material = SCNMaterial()
        material.diffuse.contents = color
        
        let cylinder: SCNCylinder = SCNCylinder(radius: 0.025, height: length)
        cylinder.radialSegmentCount = 3
        cylinder.firstMaterial = material
        
        let cylinderNode = SCNNode()
        cylinderNode.geometry = cylinder
        
        return cylinderNode

    }
    
    func toColor() -> UIColor? {
        
        let f = self.length() / 0.15
        
        let color = UIColor.colorFromFloat(start: UIColor.Theme.startColor, end: UIColor.Theme.endColor, f: CGFloat(f))
        return color
        
    }
    
}

public extension Float {
    
    func isCloseTo(_ n: Float) -> Bool {
        
        return abs(self - n) < 0.000001
    }

    static func sigmoid(x: Float) -> Float {
        return 1 / (1 + exp(-x))
    }
    
    var radian: Float {
        return self * Float.pi / 180
    }
    
    var degrees: Float {
        return self * 180 / Float.pi
    }
    
}

extension UIColor {
    
    enum Theme {
        static var fieldLinesColor: UIColor {
            return #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        }
        static var vectorColor: UIColor {
            return #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        }
        static var startColor: UIColor {
            return #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        }
        static var endColor: UIColor {
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        static var negativeCharge: UIColor {
            return #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
        static var positiveCharge: UIColor {
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        static var control: UIColor {
            return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5)
        }
        static var panel: UIColor {
            return #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 0.5)
        }
        
        
    }

    static func colorFromFloat(start: UIColor, end: UIColor, f: CGFloat) -> UIColor? {
        
        guard let c1 = start.cgColor.components, let c2 = end.cgColor.components else { return nil }
        
        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
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
    
    func setColor(from E: SCNVector3) {
     
        let f = E.length() / 0.15
       
        let color = UIColor.colorFromFloat(start: UIColor.blue, end: UIColor.red, f: CGFloat(f))
        
        self.geometry?.firstMaterial?.diffuse.contents = color
        
    }
    
    public static func Vector(length: CGFloat = 0.2) -> SCNNode {
        
        let parentNode = SCNNode()
        
        let cone: SCNCone = SCNCone(topRadius: 0, bottomRadius: 0.05, height: 0.15)
        cone.radialSegmentCount = 3
        let coneNode = SCNNode()
        coneNode.geometry = cone
        coneNode.position = SCNVector3(0, length + 0.075, 0)
        parentNode.addChildNode(coneNode)
        
        let cylinder: SCNCylinder = SCNCylinder(radius: 0.025, height: length)
        cylinder.radialSegmentCount = 3
        let cylinderNode = SCNNode()
        cylinderNode.geometry = cylinder
        cylinderNode.position = SCNVector3(0, length / 2, 0)
        parentNode.addChildNode(cylinderNode)
        
        return parentNode.flattenedClone()
        
    }
    
    public static func LineSegment(_ color: UIColor, length: CGFloat = 0.2) -> SCNNode {
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        
        let cylinder: SCNCylinder = SCNCylinder(radius: 0.025, height: length)
        cylinder.radialSegmentCount = 3
        cylinder.firstMaterial = material
        
        let cylinderNode = SCNNode()
        cylinderNode.geometry = cylinder
        
        return cylinderNode
        
    }
    
}


class ColoredStackView: UIStackView {
    
    var color: UIColor?
    
    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0
    
    var cornerRadius: CGFloat = 0.0
    var borderColor: UIColor = .red
    override var backgroundColor: UIColor? {
        get { return color }
        set {
            color = newValue
            self.setNeedsLayout()
        }
    }
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLayer.path = UIBezierPath(roundedRect:
            CGRect(x: leftInset,
                   y: topInset,
                   width: self.bounds.width - leftInset - rightInset,
                   height: self.bounds.height - topInset - bottomInset),
                                            cornerRadius: cornerRadius).cgPath
        backgroundLayer.borderColor = self.borderColor.cgColor
        backgroundLayer.borderWidth = 2
        backgroundLayer.fillColor = self.backgroundColor?.cgColor
    }
}
