//
//  K.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 09/12/2021.
//

import Foundation
import UIKit

// let VC = UIStoryboard(name: "VCStoryBoardName", bundle: nil).instantiateViewController(withIdentifier: "InstructionScreenController") as! VC

struct K {
    static let createAccountTitle = "Create an Account"
    static let verificationVCID = "VerificationViewController"
    static let rootNC = "RootNavigationController"
    static let loginVCID = "LoginViewController"
    
    static let mainStoryboard = "Main"
    static let dashboardStoryboard = "Dashboard"
    static let dashboardTabBarID = "DashboardTab"
    
    static let darkBrown = #colorLiteral(red: 0.5254901961, green: 0.3960784314, blue: 0.2901960784, alpha: 1)
    static let lightBrown: UIColor = .systemBrown.withAlphaComponent(0.3)
    
    static let lightGrey: UIColor = .systemGray4.withAlphaComponent(0.3)
    static let darkGrey: UIColor = .systemGray.withAlphaComponent(0.6)
}

enum Roles: String {
    case admin = "admin"
    case user = "user"
    case carOwner = "car"
}
