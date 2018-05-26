import SceneKit

public class ChargedNode: SCNNode {
    
    public var charges: [SCNVector4]!
    public var fieldLinesStartingPoints: [SCNVector3]!
    
    var charge: Float = 0
    
    public init(charge: Float, position: SCNVector3, geometry: SCNGeometry) {
        super.init()
        
        self.charge = charge
        self.position = position
        self.geometry = geometry
        
        if charge > 0 {
            self.geometry!.firstMaterial?.diffuse.contents = UIColor.red
        } else {
            self.geometry!.firstMaterial?.diffuse.contents = UIColor.blue
        }
        
    }
    
    public func setupVerticesAndCharges(callback: @escaping () -> ()){}
    
    public func putChargesAt(points: [SCNVector3]) {
        
        self.charges = points.map { SCNVector4($0.x, $0.y, $0.z, charge / Float(points.count)) }
    }
    
    public override init(){
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    
}

public class PointCharge: ChargedNode {
    
    public init(charge: Float, position: SCNVector3) {
        
        let radius: Float = abs(charge) *  0.25
        let sphere = SCNSphere(radius: CGFloat(radius))
        
        super.init(charge: charge, position: position, geometry: sphere)
        
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
    
    public init(charge: Float, position: SCNVector3, length: CGFloat) {
        
        let radius: Float = 0.1
        
        let cylinder = SCNCylinder(radius: CGFloat(radius), height: length)
        
        super.init(charge: charge, position: position, geometry: cylinder)
        
        var sourcePoints = [SCNVector3]()
        var chargePoints = [SCNVector3]()
        
        let n = Int(length)
        
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
  
    public override init(){
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
}


public class ChargedPlate: ChargedNode {
    
    public init(charge: Float, position: SCNVector3, length: CGFloat, height: CGFloat) {
        
        let box = SCNBox(width: 0.02, height: height, length: length, chamferRadius: 0)
        
        super.init(charge: charge, position: position, geometry: box)
        
        var sourcePoints = [SCNVector3]()
        var chargePoints = [SCNVector3]()
        
        let n = Int(length)
        let m = Int(height)
        
        for i in 0...n {
            
            let z = -Float(length / 2) + Float(i) *  Float(length) / Float(n)
            
            for j in 0...m {
                
                let y = -Float(height / 2) + Float(j) *  Float(height) / Float(m)
                
                let x: Float = 0.01
                
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
    
    public override init(){
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
}
