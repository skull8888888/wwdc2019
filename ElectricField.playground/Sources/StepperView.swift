import Foundation
import UIKit

protocol StepperViewDelegate: AnyObject {
    func stepperView(_ stepperView: StepperView, didChangeValue value: Int)
}

class StepperView: UIStackView {
    
    var value: Int = 0 {
        didSet {
            self.valueLabel.text = "\(self.value)"
            self.stepper.value = Double(value)
        }
    }
    
    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var maxValue: Int = 10
    
    weak var delegate: StepperViewDelegate?
    
    lazy var valueLabel: UILabel = {
        
        let label: UILabel = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = .white
        label.text = "1"
        label.textAlignment = .right
        label.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return label
        
    }()
    
    lazy var titleLabel: UILabel = {
        
        let label: UILabel = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = .white
        label.textAlignment = .right
        label.numberOfLines = 0
        
        return label
        
    }()
    
    lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.tintColor = UIColor.Theme.control
        stepper.addTarget(self, action: #selector(stepperDidChangeValue), for: .touchUpInside)
        return stepper
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.value = 1
        
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(valueLabel)
        self.addArrangedSubview(stepper)
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = 8
        
    }
    
    override func layoutSubviews() {
        self.updateConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func stepperDidChangeValue(_ stepper: UIStepper) {
        self.value = Int(stepper.value)
        self.delegate?.stepperView(self, didChangeValue: self.value)
    }
    
}
