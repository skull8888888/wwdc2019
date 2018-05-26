/*:

 ## Chapter 2. Charged Rod
 
 Charged rod is simply a rod with a charge that is uniformly distributed along it.
 
 In textbooks students often face electrostatics problems that involve charged rods and are asked to calculute field around it. So, it would be helpful to give visual insight on what electric field around charged rod looks like in 3d space.
*/
import PlaygroundSupport
import SceneKit

let frame = CGRect(x: 0, y: 0, width: 600, height: 600)
let EFView = ElectricFieldView(frame:frame)
/*:
 - Experiment:
 Discover the electric field around the charged rod via uncommenting lines below. Feel free to play with rod's charge and length.
*/
//:  - Important: Uncomment only one experiment at a time to prevent any charge overlapping


let rod = ChargedRod(charge: 1, position: SCNVector3(0,0,0), length: 10)
EFView.E.add(rod)
EFView.E.drawFieldLines()
//EFView.E.drawVectorField(n: 5)


//:  - Important: Notice how field lines spread radially from the rod
/*:
 - Experiment:
 What will happen if we put point charges near the charged rod?
 */


//let rod = ChargedRod(charge: 4, position: SCNVector3(0,0,0), length: 10)
//EFView.E.add(rod)
//EFView.E.add(PointCharge(charge: 1, position: SCNVector3(4,0,0)))
//EFView.E.add(PointCharge(charge: -1, position: SCNVector3(2,4,0)))
//EFView.E.drawFieldLines()
////EFView.E.drawVectorField(n: 5)


/*:
 - Experiment:
 In textbooks students also face infinite charged rods problems. Let's try to replicate them with a very very long charged rod and see what's happening!
*/


//let rod = ChargedRod(charge: 100, position: SCNVector3(0,0,0), length: 100)
//EFView.E.add(rod)
//EFView.E.drawVectorField(n: 5)

PlaygroundPage.current.liveView = EFView
/*:
 Fascinating! However, further we will see even more fascinating configurations - charged plates! Proceed to the next chapter -> [Chapter 3. Charged Plate](Chapter%203.%20Charged%20Plate)
 */
