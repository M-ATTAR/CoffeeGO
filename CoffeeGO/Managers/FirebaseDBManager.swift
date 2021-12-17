//
//  FirebaseDBManager.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 12/12/2021.
//

import Foundation
import FirebaseFirestore
import RxSwift
import RxCocoa

class FirebaseDBManager {
    
    let db = Firestore.firestore()
    let adminsSubject = PublishSubject<[Admin]>()
    let carOwnerSubject = PublishSubject<[CarOwner]>()
    let ordersSubject = PublishSubject<[Order]>()
    
    func getAdminsPS() {
        
        var admin = Admin()
        var tempAdmins: [Admin] = []
        
        self.db.collection("users").order(by: "name").whereField("role", isEqualTo: "admin").getDocuments { snapshot, error in
            if let error = error {
                self.adminsSubject.onError(error)
            } else {
                for document in snapshot!.documents {
                    admin.email = document.data()["email"] as! String
                    admin.name = document.data()["name"] as! String
                    
                    tempAdmins.append(admin)
                }
                self.adminsSubject.onNext(tempAdmins)
            }
        }
    }
    
    func getCars() {
        var carOwner = CarOwner()
        var tempCarOwners = [CarOwner]()
        
        self.db.collection("users").order(by: "addedTimestamp", descending: true).whereField("role", isEqualTo: "carOwner").getDocuments { snapshot, error in
            if let error = error {
                self.carOwnerSubject.onError(error)
            } else {
                for document in snapshot!.documents {
                    
                    carOwner.name           = document.data()["name"] as? String
                    carOwner.email          = document.data()["email"] as? String
                    carOwner.phoneNumber    = document.data()["phoneNumber"] as? String
                    carOwner.addedTimestamp = document.data()["addedTimestamp"] as? Timestamp
                    carOwner.nationalID     = document.data()["nationalID"] as? String
                    carOwner.isActive       = document.data()["isActive"] as? Bool
                    carOwner.location       = document.data()["location"] as? GeoPoint
                    carOwner.totalRevenue   = document.data()["totalRevenue"] as? Double
                    carOwner.city           = document.data()["city"] as? String
                    carOwner.uid            = document.data()["uid"] as? String
                    carOwner.totalOrders    = document.data()["totalOrders"] as? Int
                    
                    tempCarOwners.append(carOwner)
                }
                
                self.carOwnerSubject.onNext(tempCarOwners)
            }
        }
    }
    
    func getOrders(role: Roles, uid: String) {
        var order = Order()
        var tempOrders = [Order]()
        
        self.db.collection("orders").order(by: "timestamp", descending: true).whereField(role.rawValue, isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                self.ordersSubject.onError(error)
            } else {
                for document in snapshot!.documents {
                    order.carOwner = document.data()["carOwner"] as? String
                    order.userID = document.data()["userID"] as? String
                    order.price = document.data()["price"] as? Double
                    order.timestamp = document.data()["timestamp"] as? Timestamp
                    order.orderDetails = document.data()["orderDetails"] as? String
                    
                    tempOrders.append(order)
                }
                
                self.ordersSubject.onNext(tempOrders)
            }
        }
    }
    
    func deleteCarOwner(uid: String) {
//        var carOwnerToDelete = CarOwner()
        self.db.collection("users").document(uid).getDocument { snapshot, error in
            if let snapshot = snapshot {
                self.db.collection("deleted").document(uid).setData(["name": snapshot.get("name") as? String])
                self.db.collection("users").document(uid).delete()
            }
        }
        
        
    }
    
}
