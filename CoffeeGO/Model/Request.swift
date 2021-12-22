//
//  Request.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 18/12/2021.
//

import Foundation
import FirebaseFirestore

struct Request {
    var city: String?
    var location: GeoPoint?
    var nationalID: String?
    var timestamp: Timestamp?
    var uid: String?
    var name: String?
}
