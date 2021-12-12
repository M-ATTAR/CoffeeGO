//
//  CGTextField.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 11/12/2021.
//

import UIKit

@IBDesignable class CGTextField: UITextField {
    
    @IBInspectable var attPlaceholder: String = "Placeholder" {
        didSet {
            attributedPlaceholder = NSAttributedString(string: attPlaceholder, attributes: [ NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5) ])
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = K.darkBrown
        font = UIFont.systemFont(ofSize: 16)
        tintColor = .systemBrown
        textColor = .white
        
        addPaddingBeforeText()
    }
    
}
