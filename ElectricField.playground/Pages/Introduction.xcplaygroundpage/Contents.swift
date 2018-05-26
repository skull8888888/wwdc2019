
/*:
 # Static Electric Field visualization with SceneKit

 The goal of this project is to provide a tool for 3D visualization of the electric field around different charged objects.

 ## What is an electric field?
 
 From the physical point of view, the electric field is a special type of matter surrounding electric charges, which has an energy and transfers this energy via an act-on-the-distance force to other charges.
 
 From the perspective of mathematics, the electric field is a 3-dimensional vector function (vector field) that associates to each point in space an electric force (Coulomb force), that would be experienced by **positive charge** per unit of charge. In other words, it associates to each point in space such a vector that if we multiply this vector by a test charge, call it 'q', we would get a force on 'q' from the field source charge, call it 'Q'.

 - - -
 
 So, basically: (vector quantities are bold)
 
**E** = **F** / q

**E** = (k * Q / r^2) * **r** (f)
 
 - k - coefficient
 - Q - charge
 - distance from charge to point
 - **r** - unit vector in the direction of r

 - - -
 - Important:
 Note that an electric field at a point due to several charges is a vector sum of electric field vectors at that point caused by each charge. It is a principal of superposition.
 
 ## Representation
 In this project I would primarily concentrate on the mathematical meaning of the electric field and its visualization.
 
 I represented the electric field with the `ElectricField` class which is a subclass of `SCNNode` and provides all necessary functionality for a charged objects handling and a field visualization.
*/
let E = ElectricField()
//In physics, the electric field is usually denoted with E
//: I also made a simple subclass of `SCNView` to encapsulate all necessary scene-establishing functionality - `ElectricFieldView`. It has a property `E`, which is an instance of `ElectricField`. In the next chapters, we would primarily work with this class.

import UIKit
let EFView = ElectricFieldView(frame: CGRect.zero)
EFView.E
//: Charged objects are represented by a different subclasses of the `ChargedNode` class. Color of the object represents the sign of the charge that it has - red for positive and blue for negative (standard convention). Later on, we will dive deeper into the exploration of those objects
let chargedNode = ChargedNode()

let pointCharge = PointCharge()
let chargedRod = ChargedRod()
let chargedPlate = ChargedPlate()
//: `ElectricField` class has a method `add(_ charge: ChargedNode)`, which adds a child node to `ElectricField` and manages a configuration of charges.
E.add(chargedRod)
/*:
 ## Visualization
 
 Now comes the most exciting part - visualization. Essentially, physicists have 2 ways of the electric fields visualization:
- Plotting a vector field with a vectors, and
- Electric Field lines

 Electric field lines are much more interesting and useful representation of the field. Physicists once thought: "Hey! Rather than drawing a bunch of vectors, let's make a representative line pattern where each line would be tangent to the electric field vectors along it". And that was indeed a cool idea since it provides much cleaner and visually satisfying way of making sense of the field. Field lines generally start on the positive charges and end on the negative. If there is a configuration of the same sign charges they extend to infinity.
 - Important:
 Field lines don't cross. Otherwise, it would mean that at one point electric field acts on a charge in a different directions, which is not possible.
 
 This project provides both field lines and vector field ways of visualization of the electric field.

 `E.drawFieldLines()`
 
 `E.drawVectorField(n: n)`
 
 n - is a half of the number of points on one side of the 'field cube'.
 
 Ready to see it all in action? Then, let's start with a [Chapter 1. Point charges](@next)
*/
