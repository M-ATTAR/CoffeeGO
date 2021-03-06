//
//  K.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 09/12/2021.
//

import Foundation
import UIKit

struct Constants { // Constants
    static let errorAlertTitle = "Something Unexpected Happened"
    static let createAccountTitle = "Create an Account"
}

struct ID { // View Controllers Storyboard IDs
    // Main Storyboard
    static let verificationVCID = "VerificationViewController"
    static let rootNC = "RootNavigationController"
    static let loginVCID = "LoginViewController"
    
    // Dashboard Storyboard
    static let dashboardTabBarID = "DashboardTab"
    static let carDetailsID = "CarDetailsViewController"
    static let ordersVCID = "OrdersViewController"
    static let orderDetailsVCID = "OrderDetailsViewController"
    
    // CarOwner Storyboard
    static let carOwnerTabBarID = "CarOwnerTabBar"
}

struct Storyboard { // Storyboard Names
    static let mainStoryboard = "Main"
    static let dashboardStoryboard = "Dashboard"
    static let carOwnerStoryboard = "CarOwner"
}

struct Colors {
    static let darkBrown = #colorLiteral(red: 0.5254901961, green: 0.3960784314, blue: 0.2901960784, alpha: 1)
    static let lightBrown: UIColor = .systemBrown
    
    static let lightGrey: UIColor = .systemGray4.withAlphaComponent(0.3)
    static let darkGrey: UIColor = .systemGray.withAlphaComponent(0.6)
    
    static let foregroundC = UIColor(named: "foregroundColor")
    static let backgroundC = UIColor(named: "backgroundColor")
}

enum Roles: String {
    case admin = "admin"
    case user = "user"
    case carOwner = "carOwner"
}
enum Status: Int {
    case all = 0
    case active = 1
    case inactive = 2
}
enum OrderStatus: Int {
    
    case pending = 0 // "Pending"
    case preparing = 1 // "Preparing"
    case ready = 2 // "Ready For Pickup"
    case done = 3 // "Done"
    
    case declined = 4 // "Declined"
}
