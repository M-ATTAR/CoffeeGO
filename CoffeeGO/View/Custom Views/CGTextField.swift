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
            attributedPlaceholder = NSAttributedString(string: attPlaceholder, attributes: [ NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6) ])
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
        layer.cornerRadius  = 10
        clipsToBounds       = true
        
        backgroundColor  = .systemBrown.withAlphaComponent(0.5)
        tintColor        = .white
        textColor        = .white
        
        borderStyle     = .none
        clearButtonMode = .whileEditing
        
        font = UIFont.systemFont(ofSize: 16)
        
        addPaddingBeforeText()
    }
    
    func addPaddingBeforeText() {
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftView = paddingView
        self.rightViewMode = .always
    }
    
}
