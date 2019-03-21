
/*:
 # Static Electric Field visualization with SceneKit

 3D visualization of the electric field around different charged objects.

 ## What is an electric field?
 
 From the physical point of view, the electric field is a special type of matter surrounding electric charges, which has energy and transfers this energy via an act-on-the-distance force to other charges.
 
 From the perspective of mathematics, the electric field is a 3-dimensional vector function (vector field) that associates each an electric force (Coulomb force) to each point in space, that would be experienced by **positive charge** per unit of charge. In other words, it associates to each point in space such a vector that if we multiply this vector by a test charge, call it 'q', we would get a force on 'q' from the field source charge, call it 'Q'.

 - - -
 
 So, basically: (vector quantities are bold)
 
**E** = **F** / q

**E** = (k * Q / r^2) * **r** (f)
 
 - k - coefficient
 - Q - charge
 - r - distance from charge to point
 - **r** - unit vector in the direction of r
 
 - - -
 - Important:
 Note that an electric field at a point due to several charges is a vector sum of electric field vectors at that point caused by each charge. It is a principle of superposition.
 
 ## Representation
 `ElectricField` class provides all necessary functionality for the charged objects handling and the field visualization. It has 2 modes for field visualization:
 
 - Vectors
 - Electric Field lines
 
 Visualization is color-coded, meaning:
 - Very strong electric field is represented by Red color
 - Very weak electrifc field is represented by Blue color
 
 It has a method - `add(_ charge: ChargedNode)` - which adds a charged geometrical object to the `ElectricField`.
*/
//In physics, the electric field is usually denoted with E
//Subclass of SCNNode
let E = ElectricField()

let pointCharge = PointCharge()
let chargedRod = ChargedRod()
let chargedPlate = ChargedPlate()

E.add(pointCharge)
/*:
 `ElectricFieldView` class (subclass of `SCNView`) is responsible for all functionality that this playground provides. It has a settings panel, which helps customise visualization parameters:
 
 - Visualization Mode (Mode)
 - Number of Vectors (Vector Count)
 - Number of Line Segments (Segment Count)
 
 It also allows you to easily add new charged geometry to the scene:
 - Point
 - Rod
 - Plate
 
 - Important:
 By long-pressing the object you can move it within a scene and observe how its position changes the electric field.
 
 If you tap on the charged object, configuration panel will appear. With this panel you can customize object's:
 - Geometry
 - Charge
 - Rotation

 It also has a property `E`, which is an instance of `ElectricField`, for manual charge configuration
*/
import UIKit
let EFView = ElectricFieldView(frame: CGRect.zero)
//: Ready to see it all in action? Then, let's start with [Chapter 1. Point charges](@next)
