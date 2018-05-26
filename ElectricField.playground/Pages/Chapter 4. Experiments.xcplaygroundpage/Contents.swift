
import PlaygroundSupport
import SceneKit

let frame = CGRect(x: 0, y: 0, width: 600, height: 600)
let EFView = ElectricFieldView(frame:frame)

EFView.E.add(PointCharge(charge: -1, position: SCNVector3(0,0,0)))

EFView.E.add(ChargedRod(charge: 4, position: SCNVector3(4,0,0), length: 10))

EFView.E.add(ChargedPlate(charge: 5, position: SCNVector3(-2,0,0), length: 5, height: 8))

EFView.E.drawFieldLines()
//EFView.E.drawVectorField(n: 5)

PlaygroundPage.current.liveView = EFView
