//
//  UITextField + Floating label.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 01/06/2022.
//

import Foundation
import UIKit

class FloatingLabelInputView : UIView {
    
    //MARK: - Properties
    
    private var isLabelFloating: Bool = false {
        didSet {
            transformLabel(isFloating: isLabelFloating)
        }
    }
    
    var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.systemGray4
        return line
    }()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(
            textField,
            floatingLabel,
            bottomLine
        )
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        floatingLabel.sizeToFit()
        
        textField.frame = CGRect(
            x: 0,
            y: 20,
            width: width,
            height: 20
        )
        
        bottomLine.frame = CGRect(
            x: 0,
            y: textField.bottom + 5,
            width: textField.width,
            height: 1
        )
        
        floatingLabel.frame =  CGRect(
            x: 0,
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
                    self.floatingLabel.frame.origin.y = self.textField.top - 19.5
                    self.floatingLabel.font = .systemFont(ofSize: 12, weight: .regular)
                },
                completion: nil
            )
        } else {
            UIView.animate(
                withDuration: 0.33,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.floatingLabel.frame.origin.y = self.textField.top
                    self.floatingLabel.font = .systemFont(ofSize: 16, weight: .regular)
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
        self.bottomLine.backgroundColor = .systemGray
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text == "" {
            isLabelFloating = false
        }
        self.bottomLine.backgroundColor = .systemGray4
    }
}
