/*:

 ## Chapter 2. Charged Rod
 
 Charged rod is simply a rod with a charge that is uniformly distributed along it.
 
 In textbooks students often face electrostatics problems that involve charged rods and are asked to calculute field around it. So, it would be helpful to give visual insight on what electric field around charged rod looks like in 3d space.
*/
import PlaygroundSupport
import SceneKit

let frame = CGRect(x: 0, y: 0, width: 700, height: 600)
let EFView = ElectricFieldView(frame:frame)
/*:
 - Experiment:
 Discover the electric field around the charged rod. Feel free to play with rod's charge and length.
*/
let rod = ChargedRod(charge: 1, position: SCNVector3Zero, length: 8)
EFView.E.add(rod)

//:  - Important: Notice how field lines spread radially from the rod
/*:
 - Experiment:
What will happen if we put point charges near the charged rod? Insert Point Charge and investigate.
 */
/*:
 - Experiment:
 Increase vector count to 8. First add one charged rod with a charge 5 and observe the field. Then add another rod with the same charge, but an opposite sign. What happened to the field?
 */
/*:
 - Experiment:
 Add charged rods with different lenghts and charge values. Try moving and rotating them
 */

PlaygroundPage.current.liveView = EFView
/*:
 Fascinating! Further we will see even more fascinating configurations - charged plates! Proceed to the next chapter -> [Chapter 3. Charged Plate](Chapter%203.%20Charged%20Plate)
 */
