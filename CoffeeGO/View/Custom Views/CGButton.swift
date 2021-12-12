//
//  CGButton.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 11/12/2021.
//

import UIKit

@IBDesignable class CGButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        backgroundColor = K.lightBrown
        layer.cornerRadius = 10
        setTitleColor(K.darkBrown , for: .normal)
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? K.lightBrown : K.lightGrey
            setTitleColor(K.darkBrown, for: .normal)
            setTitleColor(K.darkGrey, for: .disabled)
        }
    }
}
