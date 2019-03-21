/*:
 ## Chapter 1. Point Charges
 
 The name "point charge" speaks for itself - it is a charge concentrated at a single point. Point charge is represented with a small sphere.
*/

import PlaygroundSupport
import SceneKit

let frame = CGRect(x: 0, y: 0, width: 700, height: 600)
let EFView = ElectricFieldView(frame:frame)
/*:
 - Experiment:
 Let's start with a positive point charge at the origin.
*/

EFView.E.add(PointCharge(charge: 1, position: SCNVector3Zero))

/*:
 - Experiment:
 Tap on the charge and change its sign
 */
/*:
 - Experiment:
 Let's have a look at a configuration known as a *dipole*. Using Panel on the left, insert one positive point charge and one negative point charge.
 */
/*:
 - Experiment:
 Now investigate the field around 2 point charges with the same sign (both negative or both positive)
 */
/*:
 - Experiment:
 Feel free to experiment with different configuration of charges of different signs and magnitudes
 */
PlaygroundPage.current.liveView = EFView
/*:
 Point charges are very interesting, but let's go futher and explore electric fields around uniformly charged objects. We will start with a charged rod -> [Chapter 2. Charged Rod](Chapter%202.%20Charged%20Rod)
 */

