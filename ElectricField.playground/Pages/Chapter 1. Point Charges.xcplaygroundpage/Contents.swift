/*:
 ## Chapter 1. Point Charges
 
 The name point charge speaks for itself - it is a charge concentrated at a single point. I represented a point charge with a small sphere.
*/

import PlaygroundSupport
import SceneKit

let frame = CGRect(x: 0, y: 0, width: 600, height: 600)
let EFView = ElectricFieldView(frame:frame)
/*:
 - Experiment:
 Let's start with a positive point charge at the origin. Uncomment underlying lines to see vector field and field lines representation of a field around it.

*/
//:  - Important: Uncomment only one experiment at a time to prevent any charge overlapping


//EFView.E.add(PointCharge(charge: 1, position: SCNVector3Zero))
//EFView.E.drawFieldLines()
////EFView.E.drawVectorField(n: 5)


/*:
 - Experiment:
 Now let's see what's going on around the negative point charge
 */


//EFView.E.add(PointCharge(charge: -1, position: SCNVector3Zero))
////EFView.E.drawFieldLines()
//EFView.E.drawVectorField(n: 5)


/*:
 - Experiment:
 Cool, right? And now let's have a look at a configuration known as a *dipole* - one positive and one negative point charges
 */


//EFView.E.add(PointCharge(charge: 1, position: SCNVector3(1,0,0)))
//EFView.E.add(PointCharge(charge: -1, position: SCNVector3(-1,0,0)))
//EFView.E.drawFieldLines()
////EFView.E.drawVectorField(n: 5)


/*:
 - Experiment:
 Awesome! As I said, field lines start at positive charges and end on negative ones. But what will happen if we have 2 point charges with the same sign? See the answer below!
 */


//EFView.E.add(PointCharge(charge: 1, position: SCNVector3(1,0,0)))
//EFView.E.add(PointCharge(charge: 1, position: SCNVector3(-1,0,0)))
//EFView.E.drawFieldLines()
////EFView.E.drawVectorField(n: 5)


/*:
 - Experiment:
 Interesting! Field lines indeed go to the infinity. Now, let's have some fun with some crazy configuration below. Feel free to change it too!
 */


EFView.E.add(PointCharge(charge: -1, position: SCNVector3(4,0,0)))
EFView.E.add(PointCharge(charge: -1, position: SCNVector3(2,0,0)))
EFView.E.add(PointCharge(charge: 2, position: SCNVector3(0,0,4)))
EFView.E.add(PointCharge(charge: -3, position: SCNVector3(2,4,0)))
EFView.E.add(PointCharge(charge: 5, position: SCNVector3(2,4,5)))
EFView.E.drawFieldLines()
//EFView.E.drawVectorField(n: 6)

PlaygroundPage.current.liveView = EFView
/*:
 Points charges are indeed interesting, but let's go futher and explore electric fields around charged objects that have different configurations of distributed charges. We will start with a charged rod -> [Chapter 2. Charged Rod](Chapter%202.%20Charged%20Rod)
 */

