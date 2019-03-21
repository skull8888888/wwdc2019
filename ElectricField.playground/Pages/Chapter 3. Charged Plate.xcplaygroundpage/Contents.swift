/*:
 ## Chapter 3. Charged Plate
 
 Similar to charged rod, chared plate is plate with a uniform charge distribution. Close to the plate electric field is almost uniform, meaning it doesn't depend on the distance from the plate and stays the same. The bigger the plate, the greater the distance until which electric field is uniform. In fact, electric field above and below infinite charged plate is uniform at any point!
 */
import PlaygroundSupport
import SceneKit

let frame = CGRect(x: 0, y: 0, width: 700, height: 600)
let EFView = ElectricFieldView(frame:frame)

/*:
 - Experiment:
 Start with a positively charged plate at the origin and investigate the field. Feel free to adjust it in the way you want.
 */

EFView.E.add(ChargedPlate(charge: 1, position: SCNVector3Zero, width: 5, height: 5))

/*:
 - Experiment:
 Now, let's try to investigate the field around an infinitely large plate by using a very very long big plate!
 */
/*:
 - Experiment:
 Very famous configuration is 2 parallel charged plates with equal charges of different signs. It is called a capacitor. Let's see how the electric field surrounding it looks!
*/
/*:
 - Important:
 Notice how field between 2 plates is almost uniform. That is a basic principle of a capacitor which stores electric energy in this uniform electric field
 */
/*:
 - Experiment:
 Keep the capacitor configuration, but now try moving one plate forward and backwards. Switch to the vector field mode and observe how the field changes.
 */
/*:
 - Important: Notice that the closer two plates together, the weaker the field outside the capacitor.
*/
PlaygroundPage.current.liveView = EFView
/*:
 That is basically it. I hope you enjoyed demonstrations and found visual satisfaction in the beautiful peculiar shapes of field lines and arrangement of vectors! I am looking forward to see you on the **WWDC 2019!** If you want to experiment more, proceed to the experiments page -> [Chapter 4. Experiments](Chapter%204.%20Experiments)
 */
