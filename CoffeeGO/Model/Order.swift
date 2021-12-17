//
//  Order.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 16/12/2021.
//

import Foundation
import FirebaseFirestore

struct Order {
    var price: Double?
    var timestamp: Timestamp?
    var carOwner: String?
    var userID: String?
    var orderDetails: String?
}
