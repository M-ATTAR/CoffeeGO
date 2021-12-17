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
        backgroundColor = Colors.foregroundC!
        layer.cornerRadius = 10
        setTitleColor(Colors.backgroundC!, for: .normal)
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? Colors.foregroundC! : Colors.lightGrey
            setTitleColor(Colors.backgroundC!, for: .normal)
            setTitleColor(Colors.darkGrey, for: .disabled)
        }
    }
}
