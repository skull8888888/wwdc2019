import Foundation
import UIKit
import SceneKit


class PanelView: ColoredStackView {
    
    weak var EFView: ElectricFieldView! {
        didSet {
            self.nStepper.value = EFView.vectorFieldCount
            self.segmentsStepper.value = EFView.segmentCount
            self.modeStepper.value = EFView.visualizationType.rawValue
        }
    }

    lazy var toggleButton: UIButton = {
       
        let button = UIButton()
        button.setTitle("Show panel", for: .normal)
        button.titleLabel?.font = button.titleLabel!.font.withSize(14)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return button
        
    }()
    
    lazy var modeStepper: StepperView = {
        let stepper = StepperView(frame: .zero)
        stepper.stepper.maximumValue = 1
        stepper.stepper.minimumValue = 0
        stepper.stepper.value = 0
        stepper.valueLabel.layer.opacity = 0
        stepper.title = "Mode"
        
        stepper.stepper.setIncrementImage(UIImage(named: "fieldLinesIcon.png"), for: .normal)
        stepper.stepper.setDecrementImage(UIImage(named: "vectorFieldIcon.png"), for: .normal)
        stepper.isHidden = true
        
        
        return stepper
    }()

    lazy var nStepper: StepperView = {
        let stepper = StepperView(frame: .zero)
        stepper.title = "Vector\ncount"
        stepper.isHidden = true
        
        return stepper
    }()
    
    lazy var segmentsStepper: StepperView = {
        let stepper = StepperView(frame: .zero)
        
        stepper.title = "Segment\ncount"
        stepper.stepper.stepValue = 10
        stepper.stepper.maximumValue = 100
        stepper.stepper.minimumValue = 10
        stepper.isHidden = true
        return stepper
    }()
    
    lazy var selector: UISegmentedControl = {
       
        let selector = UISegmentedControl(items: ["Point", "Plate", "Rod"])
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        selector.setTitleTextAttributes(titleTextAttributes, for: .selected)
        selector.tintColor = UIColor.Theme.control
        selector.isHidden = true
        
        return selector
        
    }()
    
    lazy var insertButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = button.titleLabel!.font.withSize(12)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.Theme.control.cgColor
        button.tintColor = UIColor.Theme.control
        button.setTitleColor(UIColor.Theme.control, for: .normal)
        button.layer.cornerRadius = 4
        button.widthAnchor.constraint(equalToConstant: 42).isActive = true
        button.layer.cornerRadius = 4
        
        button.isHidden = true
        
        return button
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cornerRadius = 8
        self.backgroundColor = UIColor.Theme.panel

        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        [
            toggleButton,
            modeStepper,
            nStepper,
            segmentsStepper,
            selector,
            insertButton
            ].forEach {self.addArrangedSubview($0)}
        
        [
            modeStepper,
            nStepper,
            segmentsStepper,
        ].forEach {$0.delegate = self}
    
        self.axis = .vertical
        self.alignment = .trailing
        self.distribution = .fill
        self.spacing = 8

        toggleButton.addTarget(self, action: #selector(toggleButtonDidTapped), for: .touchUpInside)
        insertButton.addTarget(self, action: #selector(insertButtonDidTapped), for: .touchUpInside)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func insertButtonDidTapped(button: UIButton) {
        
        var chargedNode: ChargedNode?
        
        switch self.selector.selectedSegmentIndex {
        case 0: chargedNode = PointCharge(charge: 1, position: SCNVector3Zero)
        case 1: chargedNode = ChargedPlate(charge: 1, position: SCNVector3Zero, width: 5, height: 5)
        case 2: chargedNode = ChargedRod(charge: 1, position: SCNVector3Zero, length: 5)
        default: break
        }
        
        guard let node = chargedNode else { return }
        
        self.EFView.E.add(node)
        
        
    }
    
    @objc func toggleButtonDidTapped(button: UIButton) {
        
        let title = !modeStepper.isHidden ? "Show panel" : "Hide panel"
        
        toggleButton.setTitle(title, for: .normal)
        
        self.arrangedSubviews.forEach { (view) in
            if view != self.toggleButton {
                view.isHidden = !view.isHidden
            }
        }
        
    }
    
}

extension PanelView: StepperViewDelegate {
    
    func stepperView(_ stepperView: StepperView, didChangeValue value: Int) {
        
        switch stepperView.title {
        case "Mode":
            self.EFView.visualizationType = ElectricFieldView.VisualizationType(rawValue: value)!
        case "Vector\ncount":
            self.EFView.vectorFieldCount = value
            self.EFView.visualizationType = .vectorField
            self.modeStepper.value = 0
        case "Segment\ncount":
            self.EFView.visualizationType = .fieldLines
            self.EFView.segmentCount = value
            self.modeStepper.value = 1
        default: break
        }
        
        self.EFView.visualize()
    
    }
    
}
