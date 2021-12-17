//
//  CarOwner.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 15/12/2021.
//

import Foundation
import FirebaseFirestore

struct CarOwner {
    var location: GeoPoint?
    var name: String?
//    - Image or Logo
    var nationalID: String?
    var email: String?
    var totalRevenue: Double?
//    - Orders (Pending, Accepted and being prepared, Delivered)
//    - Menu
//    - Status
    var phoneNumber: String?
    var isActive: Bool?
    var addedTimestamp: Timestamp?
    var city: String?
    var uid: String?
    var totalOrders: Int?
}

