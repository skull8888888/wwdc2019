
import PlaygroundSupport
import SceneKit

let frame = CGRect(x: 0, y: 0, width: 700, height: 600)
let EFView = ElectricFieldView(frame: frame, options:    [SCNView.Option.preferredRenderingAPI.rawValue: NSNumber(value: SCNRenderingAPI.metal.rawValue)])

EFView.E.add(PointCharge(charge: 1, position: SCNVector3Zero))
EFView.E.add(PointCharge(charge: -1, position: SCNVector3(5,0,0)))
EFView.E.add(ChargedRod(charge: 1, position: SCNVector3(4,0,0), length: 10))
EFView.E.add(ChargedPlate(charge: -5, position: SCNVector3(-2,0,0), width: 10, height: 8))
EFView.E.add(ChargedPlate(charge: 5, position: SCNVector3(-3,0,0), width: 10, height: 8))

PlaygroundPage.current.liveView = EFView
