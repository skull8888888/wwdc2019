/*:
 ## Chapter 3. Charged Plate
 
 Similar to chared rod, chared plate is plate with a uniform charge distribution. Close to the plate electric field is almost uniform, meaning it doesn't depend on the distance from the plate and stays the same. The bigger the plate, the greater the distance until which electric field is uniform. In fact, electric field above and below infinite charged plate is uniform at any point!
 */
import PlaygroundSupport
import SceneKit

let frame = CGRect(x: 0, y: 0, width: 600, height: 600)
let EFView = ElectricFieldView(frame:frame)

/*:
 - Experiment:
 Start with a positively charged plate at the origin
 */
//:  - Important: Uncomment only one experiment at a time to prevent any charge overlapping


//EFView.E.add(ChargedPlate(charge: 1, position: SCNVector3Zero, length: 5, height: 5))
////EFView.E.drawVectorField(n: 5)
//EFView.E.drawFieldLines()


/*:
 - Experiment:
 Now, let's try to investigate the field around an infinitely large plate by using a very very long big plate!
 */


//let plate = ChargedPlate(charge: 1000, position: SCNVector3(0,0,0), length: 100, height: 100)
//EFView.E.add(plate)
////EFView.E.drawVectorField(n: 5)


/*:
 - Important:
Notice how all vectors despite the distance have the same magnitude! It is very easy to prove mathematically using integration but here we can just see it and I think that it is just amazing!
 */
/*:
 - Experiment:
 Another very famous configuration is 2 parallel charged plates with equal charges of different signs. It is called a capacitor. Let's see how the electric field surrounding it looks!
*/


//EFView.E.add(ChargedPlate(charge: 10, position: SCNVector3(-2,0,0), length: 5, height: 5))
//EFView.E.add(ChargedPlate(charge: -10, position: SCNVector3(2,0,0), length: 5, height: 5))
////EFView.E.drawFieldLines()
//EFView.E.drawVectorField(n: 5)


/*:
 - Important:
 Notice how field between 2 plates is almost uniform. That is a basic principle of a capacitor which stores electric energy in this uniform electric field
 */
/*:
 - Experiment:
 Now, it is time for a capacitor with an infinitely(almost) large plates! Bring it in!
 */


//EFView.E.add(ChargedPlate(charge: 1000, position: SCNVector3(-2,0,0), length: 100, height: 100))
//EFView.E.add(ChargedPlate(charge: -1000, position: SCNVector3(2,0,0), length: 100, height: 100))
//EFView.E.drawVectorField(n: 5)


/*:
 - Important:
 Notice how between plates we have twice the length of the vectors that we saw with 1 'infinite' plate in the previous example. Also, see how field between plates is very strong, whereas field outside is almost negligible. In fact, in case of an infinite capacitor, the electric field exists only within a capacitor because it exactly cancels out on the outside!
 */
PlaygroundPage.current.liveView = EFView
/*:
 That is basically it. I hope you enjoyed demonstrations and found visual satisfaction in the beautiful peculiar shapes of field lines and arrangement of vectors! I am looking forward to see you on the **WWDC 2018!** If you want to experiment more, proceed to the experiments page -> [Chapter 4. Experiments](Chapter%204.%20Experiments)
 */
