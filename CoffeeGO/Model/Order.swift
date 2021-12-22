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
    var carOwnerID: String?
    var carOwnerName: String?
    var userName: String?
    var userID: String?
    var orderDetails: String?
    var orderID: String?
    var status: String?
}
