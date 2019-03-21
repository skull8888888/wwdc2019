import SceneKit

public class ChargedNode: SCNNode {
    
    public var chargedPoints: [SCNVector3]!
    public var charges: [SCNVector4]!
    public var fieldLinesStartingPoints: [SCNVector3]!

    public var width: CGFloat = 0.0
    public var height: CGFloat = 0.0
    public var length: CGFloat = 0.0
    
    var charge: Float = 0 {
        didSet {
            if self.chargedPoints != nil {
                self.putChargesAt(points: self.chargedPoints)
            }
            
            self.updateMaterial()
    
        }
        
    }
    
    public init(charge: Float, position: SCNVector3, geometry: SCNGeometry) {
        super.init()
        
        self.charge = charge
        self.position = position
        self.geometry = geometry
        
        self.updateMaterial()
    }
    
    public func putChargesAt(points: [SCNVector3]) {
        self.chargedPoints = points
        self.charges = points.map { SCNVector4($0.x, $0.y, $0.z, self.charge / Float(points.count)) }
    }
    
    public override init(){
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    func updateNode() {
        
    }
    
    func updateMaterial(){
        if self.charge > 0 {
            self.geometry!.firstMaterial?.diffuse.contents = UIColor.Theme.positiveCharge
        } else {
            self.geometry!.firstMaterial?.diffuse.contents = UIColor.Theme.negativeCharge
        }
    }
    
}

public class PointCharge: ChargedNode {
    
    public init(charge: Float, position: SCNVector3) {
        
        let r: CGFloat = 0.25
        let radius: Float = 0.5
        let sphere = SCNSphere(radius: r)
        
        super.init(charge: charge, position: position, geometry: sphere)
        
        self.name = "Point Charge"
    
        var points = [SCNVector3]()

        for i in 0...5 {

            for j in 1...3 {

                let teta = Float(j) * Float.pi / 4
                let fi = Float(i) * Float.pi / 3

                let y = cos(teta) * radius

                let z = sin(teta) * cos(fi) * radius

                let x = sin(teta) * sin(fi) * radius

                points.append(SCNVector3(x,y,z))

            }

        }

        points.append(SCNVector3(0,radius,0))
        points.append(SCNVector3(0,-radius,0))

        self.fieldLinesStartingPoints = points
        self.putChargesAt(points: [SCNVector3Zero])

    }
    
    public override init(){
        super.init()
    }
  
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
}

public class ChargedRod: ChargedNode {
    
    let radius: Float = 0.1
    
    public init(charge: Float, position: SCNVector3, length: CGFloat) {
    
        let cylinder = SCNCylinder(radius: CGFloat(radius), height: length)
        
        super.init(charge: charge, position: position, geometry: cylinder)
        
        self.charge = charge
        self.name = "Charged Rod"
        self.length = length
        
        self.updateNode()

    }
  
    public override init(){
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func updateNode(){
        
        let cylinder = SCNCylinder(radius: CGFloat(self.radius), height: self.length)
        
        self.geometry = cylinder
        self.updateMaterial()
        
        var sourcePoints = [SCNVector3]()
        var chargePoints = [SCNVector3]()
        
        let n = Int(self.length)
        
        for i in 0...n {
            
            let y = -Float(length) / 2 + Float(length) / Float(n) * Float(i)
            
            sourcePoints += [
                SCNVector3(radius,y,radius),
                SCNVector3(-radius,y,radius),
                SCNVector3(radius,y,-radius),
                SCNVector3(-radius,y,-radius)
            ]
            
            if i != n {
                for j in 0...10 {
                    
                    let dy = y + Float(j) * Float(length) / Float(n * 10)
                    chargePoints.append(SCNVector3(0,dy,0))
                    
                }
            }
            
        }
        
        self.fieldLinesStartingPoints = sourcePoints
        self.putChargesAt(points: chargePoints)
        
    }
    
}


public class ChargedPlate: ChargedNode {
    
    public init(charge: Float, position: SCNVector3, width: CGFloat, height: CGFloat) {
        
        let box = SCNBox(width: 0.02, height: height, length: width, chamferRadius: 0)
        
        super.init(charge: charge, position: position, geometry: box)
        
        self.name = "Charged Plate"
        self.width = width
        self.height = height
        
        self.updateNode()
        
    }
    
    public override init(){
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func updateNode(){
        
        let box = SCNBox(width: 0.02, height: self.height, length: self.width, chamferRadius: 0)
        self.geometry = box
        self.updateMaterial()
        
        var sourcePoints = [SCNVector3]()
        var chargePoints = [SCNVector3]()
        
        let n = Int(width)
        let m = Int(height)
        
        for i in 0...n {
            
            let z = -Float(width / 2) + Float(i) *  Float(width) / Float(n)
            
            for j in 0...m {
                
                let y = -Float(height / 2) + Float(j) *  Float(height) / Float(m)
                
                let x: Float = 0.2
                
                sourcePoints.append(SCNVector3(x,y,z))
                sourcePoints.append(SCNVector3(-x,y,z))
                chargePoints.append(SCNVector3(0,y,z))
                
                chargePoints.append(SCNVector3(0,y,z))
                
                if i != n {
                    chargePoints.append(SCNVector3(0,y,z + Float(length) / Float(n * 2)))
                }
                
                if j != m {
                    chargePoints.append(SCNVector3(0,y + Float(height) / Float(m * 2),z))
                }
                
            }
            
        }
        
        self.fieldLinesStartingPoints = sourcePoints
        self.putChargesAt(points: chargePoints)
        
    }
    
}
