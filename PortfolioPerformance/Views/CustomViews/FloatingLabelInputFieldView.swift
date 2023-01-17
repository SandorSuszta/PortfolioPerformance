import UIKit

enum InputFieldPlaceholder: String {
    case price = "Price"
    case ammount = "Ammount"
}

class FloatingLabelInputView : UIView {
    
    //MARK: - Properties
    
    private var isLabelFloating: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.transformLabel(isFloating: self.isLabelFloating)
            }
        }
    }
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    let floatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        return label
    }()
    
    //MARK: - Lifecycle
    
    init(placeHolder: InputFieldPlaceholder) {
        super.init(frame: .zero)
        addSubviews(
            textField,
            floatingLabel
        )
        textField.delegate = self
        floatingLabel.text = placeHolder.rawValue
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        floatingLabel.sizeToFit()
        
        textField.frame = CGRect(
            x: 10,
            y: 15,
            width: width,
            height: 20
        )
        
        floatingLabel.frame =  CGRect(
            x: 10,
            y: textField.top,
            width: floatingLabel.width,
            height: floatingLabel.height
        )
    }
    //MARK: - Methods
    
    private func transformLabel(isFloating: Bool) {
        if isFloating == true {
            UIView.animate(
                withDuration: 0.33,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.floatingLabel.frame.origin.y = 5
                    self.floatingLabel.font = .systemFont(ofSize: 12, weight: .regular)
                    self.textField.frame.origin.y = 25
                },
                completion: nil
            )
        } else {
            UIView.animate(
                withDuration: 0.33,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.floatingLabel.frame.origin.y = 20
                    self.floatingLabel.font = .systemFont(ofSize: 16, weight: .regular)
                    self.textField.frame.origin.y = 20
                },
                completion: nil
            )
        }
    }
}

//MARK: - Text Field Delegate Methods

extension FloatingLabelInputView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isLabelFloating = true
        layer.borderColor = UIColor.PPBlue.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text == "" {
            isLabelFloating = false
        }
        layer.borderColor = UIColor.systemGray4.cgColor
    }
}

