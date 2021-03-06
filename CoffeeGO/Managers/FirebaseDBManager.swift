//
//  FirebaseDBManager.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 12/12/2021.
//

import Foundation
import FirebaseFirestore
import Firebase
import RxSwift
import RxCocoa

class FirebaseDBManager {
    
    let db = Firestore.firestore()
    let adminsSubject = PublishSubject<[Admin]>()
    let carOwnerSubject = PublishSubject<[CarOwner]>()
    let ordersSubject = PublishSubject<[Order]>()
    let requestsSubject = PublishSubject<[Request]>()
    let isActiveSubject = PublishSubject<Bool>()
    
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
        
        self.db.collection("users").order(by: "addedTimestamp", descending: true).whereField("role", isEqualTo: "carOwner").addSnapshotListener { snapshot, error in
            if let error = error {
                self.carOwnerSubject.onError(error)
            } else {
                tempCarOwners = []
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
        
        self.db.collection("orders").order(by: "timestamp", descending: true).whereField(role.rawValue, isEqualTo: uid).addSnapshotListener { snapshot, error in
            if let error = error {
                self.ordersSubject.onError(error)
            } else {
                tempOrders = []
                for document in snapshot!.documents {
                    order.carOwnerID   = document.data()["carOwnerID"] as? String
                    order.carOwnerName = document.data()["carOwnerName"] as? String
                    order.userName     = document.data()["userName"] as? String
                    order.userID       = document.data()["userID"] as? String
                    order.price        = document.data()["price"] as? Double
                    order.timestamp    = document.data()["timestamp"] as? Timestamp
                    order.orderDetails = document.data()["orderDetails"] as? String
                    order.orderID      = document.data()["orderID"] as? String
                    order.status       = document.data()["status"] as? String
                    
                    tempOrders.append(order)
                }
                
                self.ordersSubject.onNext(tempOrders)
            }
        }
    }
    
    func getOrdersForTimestamp(uid: String, timestamp: Date) {
        let timestamp = Timestamp(date: timestamp)
        var order = Order()
        var tempOrders = [Order]()
        
        self.db.collection("orders").order(by: "timestamp", descending: true).whereField(Roles.carOwner.rawValue, isEqualTo: uid).whereField("timestamp", isEqualTo: timestamp).getDocuments { snapshot, error in
            if let error = error {
                self.ordersSubject.onError(error)
            } else {
                tempOrders = []
                for document in snapshot!.documents {
                    order.carOwnerID   = document.data()["carOwnerID"] as? String
                    order.carOwnerName = document.data()["carOwnerName"] as? String
                    order.userName     = document.data()["userName"] as? String
                    order.userID       = document.data()["userID"] as? String
                    order.price        = document.data()["price"] as? Double
                    order.timestamp    = document.data()["timestamp"] as? Timestamp
                    order.orderDetails = document.data()["orderDetails"] as? String
                    order.orderID      = document.data()["orderID"] as? String
                    order.status       = document.data()["status"] as? String
                    
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
    
    func getRequests() {
        var requests = Request()
        var tempReq = [Request]()
        
        self.db.collection("requests").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                self.requestsSubject.onError(error)
            } else {
                tempReq = []
                
                for document in snapshot!.documents {
                    requests.uid = document.data()["uid"] as? String
                    requests.timestamp = document.data()["timestamp"] as? Timestamp
                    requests.city = document.data()["city"] as? String
                    requests.nationalID = document.data()["nationalID"] as? String
                    requests.location = document.data()["location"] as? GeoPoint
                    requests.name = document.data()["name"] as? String
                    
                    tempReq.append(requests)
                }
                self.requestsSubject.onNext(tempReq)
            }
        }
    }
    
    func getReqObservable() -> Observable<[Request]> {
        var requests = Request()
        var tempReq = [Request]()
        
        return Observable.create { observer in
            
            self.db.collection("requests").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    for document in snapshot!.documents {
                        requests.uid = document.data()["uid"] as? String
                        requests.timestamp = document.data()["timestamp"] as? Timestamp
                        requests.city = document.data()["city"] as? String
                        requests.nationalID = document.data()["nationalID"] as? String
                        requests.location = document.data()["location"] as? GeoPoint
                        requests.name = document.data()["name"] as? String
                        
                        tempReq.append(requests)
                    }
                    observer.onNext(tempReq)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func acceptRequest(request: Request) {
        db.collection("users").document(request.uid!).setData(
        [
            "addedTimestamp": Timestamp(date: Date()),
            "city": request.city,
            "nationalID": request.nationalID,
            "location": request.location,
            "isActive": false,
            "totalOrders": 0,
            "totalRevenue": 0,
            "role": Roles.carOwner.rawValue
        ], merge: true ) { err in
            if let err = err {
                self.requestsSubject.onError(err)
            } else {
                self.db.collection("requests").document(request.uid!).delete()
                self.getRequests()
            }
        }
    }
    
    func declineRequest(request: Request) {
        self.db.collection("requests").document(request.uid!).delete { error in
            if let error = error {
                self.requestsSubject.onError(error)
            } else {
                self.getRequests()
            }
        }
    }
    
    func manageOrders(orderStatus: OrderStatus, orderID: String?) {
        guard let orderID = orderID else {
            return
        }
        switch orderStatus {
        case .pending:
            db.collection("orders").document(orderID).setData(["status":"Preparing"], merge: true)
        case .preparing:
            db.collection("orders").document(orderID).setData(["status":"Ready For Pickup"], merge: true)
        case .ready:
            db.collection("orders").document(orderID).setData(["status":"Done"], merge: true)
        case .done:
            print("Done")
        case .declined:
            db.collection("orders").document(orderID).setData(["status":"Declined"], merge: true)
        }
    }
    
    func manageStatus(uid: String, newStatus: Bool){
        db.collection("users").document(uid).setData(["isActive": newStatus], merge: true)
    }
    func getStatus(uid: String) {
        db.collection("users").document(uid).addSnapshotListener { snapshot, error in
            if let error = error {
                self.isActiveSubject.onError(error)
            } else {
                self.isActiveSubject.onNext( snapshot?.get("isActive") as! Bool )
            }
        }
    }
}
