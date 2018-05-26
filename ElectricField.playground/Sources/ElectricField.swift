import SceneKit

public extension UIColor {
    
    struct Theme {
        static var fieldLinesColor: UIColor {
            return #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        }
        static var vectorColor: UIColor {
            return #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        }
    }
    
}


public class ElectricField: SCNNode {
    
    lazy var charges = [SCNVector4]()
    lazy var lineStartingPoints = [SCNVector4]()
    lazy var fieldLinesNode = SCNNode()
    
    lazy var arrow: SCNNode = {
        let l: CGFloat = 0.12
        let cone = SCNCone(topRadius: 0, bottomRadius: 0.05, height: l)
        cone.firstMaterial?.diffuse.contents = UIColor.Theme.fieldLinesColor
        cone.radialSegmentCount = 12
        let node = SCNNode()
        node.position = SCNVector3(0, l / 2, 0)
        node.geometry = cone
        return node
    }()
    
    public override init() {
        super.init()
        self.addChildNode(self.fieldLinesNode)
    }
    
    public func add(_ node: ChargedNode){
    
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

    }
    
    public func drawVectorField(n: Int){
        
//        let startTime = CACurrentMediaTime()
        
        let vector = Vector()
        
        for x in (-n)...n {
            for y in (-n)...n {
                for z in (-n)...n {
                   
                    let p = SCNVector3(x,y,z)
                    let E = electricFieldAt(point: p)
                    
                    if !E.x.isNaN || !E.y.isNaN || !E.z.isNaN {
                        
                        let v = vector.clone()
                        v.position = p
                        v.direction = E
                        
                        self.addChildNode(v)
                    }
                    
                }
            }
        }
        
//        let endTime = CACurrentMediaTime()
//        print(endTime - startTime)
    }
    
    public func electricFieldAt(point: SCNVector3) -> SCNVector3 {
        
        var vectorSum = SCNVector3Zero
        
        // coefficient used in vector field formula
        // here precise value doesn't really matter
        //
        let K: Float = 0.5
        
        for q in self.charges {
            
            //position vector from charge 'q' to the point
            let R = SCNVector3.vector(SCNVector3(q.x, q.y, q.z), point)
            // thus distance from the charge 'q' to the point
            let r = R.length()
            
            if !r.isCloseTo(0) {
                // field at that point due to the charge 'q' (scalar component)
                let E = R * (K * q.w / (r * r * r))
                vectorSum = vectorSum + E
            }
    
        }
    
        return vectorSum
    }
    
    public func drawFieldLines(){
        
        //let startTime = CACurrentMediaTime()
        
        // number of prism segements in the line
        let segmentCount = 500 
        
        // radius of thickness of the line
        let radius: Float = 0.02
        
        // a small step along the tangent field vector
        // to identify next control point
        // the smaller this value the more accurate our line is
        let step: Float = 0.01
        let skip = 10
        
        // number of side in a line surrounding figure
        let n = 6
        
        // reference node to reuse during surrounding points position calculations
        let referenceNode = SCNNode()
        
        var indices = [Int32]()
        var vertices = [SCNVector3]()
        var normals = [SCNVector3]()
        var newLine = false
        
        for p in self.lineStartingPoints{
            
            var currentPoint = SCNVector3(p.x, p.y, p.z)
            
            for i in 0...segmentCount {
                
                let tangentVector = self.electricFieldAt(point: currentPoint)
                
                let deltaVector = p.w < 0 ? tangentVector.unit() * (step * -1) : tangentVector.unit() * step
                
                if i % skip == 0 {
                    
                    referenceNode.position = currentPoint
                    referenceNode.pointTowards(deltaVector)
                    
                    // retrieving 'n' points around the point
                    let points = referenceNode.getPointsAroundVector(n: n, radius: radius).map { (point: SCNVector3) -> SCNVector3 in
                        
                        let convertedPoint = referenceNode.convertPosition(point, to: self)
                        normals.append(SCNVector3.vector(currentPoint, convertedPoint))
                        
                        return convertedPoint
                        
                    }
                    
                    vertices.append(contentsOf: points)
                    
                    // making surface for the line exterior
                    if i != segmentCount {
                        
                        var startIndex = indices.count == 0 ? 0: Int(indices[indices.count - 4 * n]) + n
                        
                        if newLine {
                            startIndex += n
                            newLine = false
                        }
                        
                        for j in 0...(n - 2) {
                            indices += [
                                Int32(j + startIndex),
                                Int32(j + startIndex + 1),
                                Int32(j + startIndex + n + 1),
                                Int32(j + startIndex + n)
                            ]
                        }
                        
                        indices += [
                            Int32(n - 1 + startIndex),
                            Int32(startIndex),
                            Int32(n + startIndex),
                            Int32(2 * n - 1 + startIndex),
                        ]
                        
                    } else {
                        newLine = true
                    }
                    
                    if i == 100 {
                        let a = arrow.clone()
                        a.position = currentPoint
                        a.pointTowards(tangentVector)
                        self.addChildNode(a)
                    }
                    
                }
            
                currentPoint = currentPoint + deltaVector
                
            }
            
        }
        
        // straightforward implementation of the custom geometry from vertices, indices and normals
        
        let verticesSource = SCNGeometrySource(vertices: vertices)
        
        let primitiveCount = indices.count / 4
        let indicesPointers: [Int32] = Array(repeating: 4, count: primitiveCount)
        
        indices = indicesPointers + indices
        
        let indicesData = Data(bytes: indices, count: MemoryLayout<Int32>.size * indices.count)
        
        let element = SCNGeometryElement(data: indicesData,
                                         primitiveType: .polygon,
                                         primitiveCount: primitiveCount,
                                         bytesPerIndex: MemoryLayout<Int32>.size)
        
        let normalsSource = SCNGeometrySource(normals: normals)
        
        let geometry = SCNGeometry(sources: [verticesSource, normalsSource], elements: [element])
        geometry.firstMaterial?.diffuse.contents = UIColor.Theme.fieldLinesColor
        
        self.fieldLinesNode.geometry = geometry
        
        //let endTime = CACurrentMediaTime()
        //print(endTime - startTime)
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
}
