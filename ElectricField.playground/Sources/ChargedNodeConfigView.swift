import Foundation
import UIKit
import SceneKit

class ChargedNodeConfigView: ColoredStackView {
    
    weak var EFView: ElectricFieldView! 
    
    weak var selectedNode: ChargedNode? {
        didSet {
            
            if let node = selectedNode {
                
                if node.charge > 0 {
                    self.chargeSignStepper.value = 1
                } else {
                    self.chargeSignStepper.value = 0
                }
                
                self.chargeStepper.value = Int(abs(node.charge))
                self.titleLabel.text = node.name
            
                self.pitchStepper.value = Int(node.eulerAngles.x.degrees)
                self.yawStepper.value = Int(node.eulerAngles.y.degrees)
                self.rollStepper.value = Int(node.eulerAngles.z.degrees)
                
                [
                widthStepper,
                heightStepper,
                lengthStepper
                ].forEach {$0.isHidden = true}
                
                if node is ChargedRod {
                    self.lengthStepper.isHidden = false
                    self.lengthStepper.value = Int(node.length)
                } else if node is ChargedPlate {
                    
                    self.widthStepper.isHidden = false
                    self.widthStepper.value = Int(node.width)
                    
                    self.heightStepper.isHidden = false
                    self.heightStepper.value = Int(node.height)
                 
                }
                
            }
            
        }
        
    }
    
    lazy var titleLabel: UILabel = {
        
        let label: UILabel = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = .white
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
        
    }()
    
    lazy var chargeSignStepper: StepperView = {
        let stepper = StepperView(frame: .zero)
        stepper.title = "Sign"
        stepper.valueLabel.layer.opacity = 0
        stepper.stepper.maximumValue = 1
        stepper.stepper.minimumValue = 0
        stepper.stepper.value = 1
        return stepper
    }()
    
    lazy var chargeStepper: StepperView = {
        let stepper = StepperView(frame: .zero)
        stepper.title = "Charge"
        return stepper
    }()
    
    lazy var widthStepper: StepperView = {
        let stepper = StepperView(frame: .zero)
        stepper.title = "Width"
        return stepper
    }()
    
    lazy var heightStepper: StepperView = {
        let stepper = StepperView(frame: .zero)
        stepper.title = "Height"
        return stepper
    }()
    
    lazy var lengthStepper: StepperView = {
        let stepper = StepperView(frame: .zero)
        stepper.title = "Length"
        stepper.stepper.minimumValue = 2
        return stepper
    }()
    
    lazy var pitchStepper: StepperView = {
        let stepper = StepperView(frame: .zero)
        
        stepper.title = "Pitch"
        stepper.stepper.value = 0
        stepper.stepper.stepValue = 5
        stepper.stepper.maximumValue = 180
        stepper.stepper.minimumValue = -180
        return stepper
    }()
    
    lazy var yawStepper: StepperView = {
        let stepper = StepperView(frame: .zero)
        
        stepper.title = "Yaw"
        stepper.stepper.value = 0
        stepper.stepper.stepValue = 5
        stepper.stepper.maximumValue = 180
        stepper.stepper.minimumValue = -180
        return stepper
    }()
    
    lazy var rollStepper: StepperView = {
        let stepper = StepperView(frame: .zero)
        
        stepper.title = "Roll"
        stepper.stepper.value = 0
        stepper.stepper.stepValue = 5
        stepper.stepper.maximumValue = 180
        stepper.stepper.minimumValue = -180
        return stepper
    }()
    
    lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Remove", for: .normal)
        button.titleLabel?.font = button.titleLabel!.font.withSize(12)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5)
        button.tintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5)
        button.setTitleColor(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5), for: .normal)
        button.layer.cornerRadius = 4
        button.widthAnchor.constraint(equalToConstant: 94).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        button.layer.cornerRadius = 4
        return button
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.cornerRadius = 8
        self.backgroundColor = UIColor.Theme.panel
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        [
            titleLabel,
            chargeSignStepper,
            chargeStepper,
            widthStepper,
            heightStepper,
            lengthStepper,
            pitchStepper,
            yawStepper,
            rollStepper,
            removeButton
        ].forEach {self.addArrangedSubview($0)}
        
        [
            chargeSignStepper,
            chargeStepper,
            widthStepper,
            heightStepper,
            lengthStepper,
            pitchStepper,
            yawStepper,
            rollStepper,
        ].forEach {$0.delegate = self}
        
        self.axis = .vertical
        self.alignment = .trailing
        self.distribution = .fill
        self.spacing = 8
       
        removeButton.addTarget(self, action: #selector(removeButtonDidTapped), for: .touchUpInside)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func removeButtonDidTapped(button: UIButton) {
        
        self.selectedNode?.removeFromParentNode()
        self.selectedNode = nil
        self.isHidden = true
        
        self.EFView.visualize()
        
    }
    
}

extension ChargedNodeConfigView : StepperViewDelegate {
    
    func stepperView(_ stepperView: StepperView, didChangeValue value: Int) {
        
        guard let selectedNode = self.selectedNode else { return }
        
        switch stepperView.title { 
        case "Charge":
            if self.chargeSignStepper.value == 1 {
                selectedNode.charge = Float(value)
            } else {
                selectedNode.charge = Float(-value)
            }
        case "Sign":
            if value == 1 {
                selectedNode.charge = abs(selectedNode.charge)
            } else {
                selectedNode.charge = -1.0 * abs(selectedNode.charge)
            }
        case "Length":
            
            selectedNode.length = CGFloat(value)
            selectedNode.updateNode()
        case "Width":
            
            selectedNode.width = CGFloat(value)
            selectedNode.updateNode()
            
        case "Height":
        
            selectedNode.height = CGFloat(value)
            selectedNode.updateNode()
            
        case "Pitch":
            selectedNode.eulerAngles.x = Float(value).radian
        case "Yaw":
            selectedNode.eulerAngles.y = Float(value).radian
        case "Roll":
            selectedNode.eulerAngles.z = Float(value).radian
            
        default: break
        }
        
        self.EFView.visualize()
        
    }
    
}
