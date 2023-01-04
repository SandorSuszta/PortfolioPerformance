//
//  TransactionDetails.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 03/01/2023.
//

import UIKit

final class TransactionDetailsView: UIView {
    
    //MARK: - Properties
    
    private let priceField = FloatingLabelInputView(placeHolder: .price)
    
    private let ammountField = FloatingLabelInputView(placeHolder: .ammount)
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.preferredDatePickerStyle = .compact
        picker.contentHorizontalAlignment = .leading
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    //MARK: - Init
    
    init(transactionType: TransactionType) {
        super .init(frame: .zero)
        setupView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setupView() {
        configureWithShadow()
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(priceField, ammountField, datePicker)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            priceField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            priceField.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            priceField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            priceField.heightAnchor.constraint(equalToConstant: 50),
            
            ammountField.topAnchor.constraint(equalTo: priceField.bottomAnchor, constant: 10),
            ammountField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            ammountField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            ammountField.heightAnchor.constraint(equalToConstant: 50),
            
            datePicker.topAnchor.constraint(equalTo: ammountField.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            datePicker.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
