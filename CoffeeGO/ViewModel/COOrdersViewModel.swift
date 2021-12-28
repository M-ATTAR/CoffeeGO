//
//  COOrdersViewModel.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 26/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

class COOrdersViewModel {
    let firebaseDB = FirebaseDBManager()
    let bag = DisposeBag()
    
    let ordersSubject = PublishSubject<[Order]>()
    let ordersDidCome = PublishSubject<Bool>()
    let errorSubject = PublishSubject<Bool>()
    
    var ordersArray = [Order]()
    
    let uid = UserDefaults.standard.string(forKey: "userID")
    
    func subToFirebase() {
        firebaseDB.ordersSubject.subscribe { orders in
            self.ordersArray = orders
            print(orders)
            self.ordersDidCome.onNext(true)
        } onError: { error in
            self.errorSubject.onError(error)
        }.disposed(by: bag)
    }
    
    func getOrders() {
        guard let uid = uid else { return }
        
        firebaseDB.getOrders(role: .carOwner, uid: uid)
    }
    func filterOrders(orderStatus: OrderStatus) {
        switch orderStatus {
        case .pending:
            ordersSubject.onNext( ordersArray.filter { $0.status == "Pending" } )
        case .preparing:
            ordersSubject.onNext( ordersArray.filter { $0.status == "Preparing" } )
        case .ready:
            ordersSubject.onNext( ordersArray.filter { $0.status == "Ready For Pickup" } )
        case .done:
            ordersSubject.onNext( ordersArray.filter { $0.status == "Done" } )
        case .declined:
            ordersSubject.onNext( ordersArray.filter { $0.status == "Declined" } )
        }
    }
    
    func manageOrders(orderStatus: OrderStatus, orderID: String?) {
        guard let orderID = orderID else {
            return
        }

        firebaseDB.manageOrders(orderStatus: orderStatus, orderID: orderID)
    }
    
//    func filterOrdersBy(timestamp: Date) {
//        guard let uid = uid else { return }
//        firebaseDB.getOrdersForTimestamp(uid: uid, timestamp: timestamp)
//    }
    
    func filterOrdersBy(timestamp: Date, withOrderStatus: OrderStatus) {
        
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: timestamp)
        
        if withOrderStatus == .done {
            ordersSubject.onNext( ordersArray.filter {
                Calendar.current.dateComponents([.day, .year, .month], from: ($0.timestamp?.dateValue())!) == calendarDate && $0.status == "Done"
            })
        } else {
            ordersSubject.onNext( ordersArray.filter {
                Calendar.current.dateComponents([.day, .year, .month], from: ($0.timestamp?.dateValue())!) == calendarDate && $0.status == "Declined"
            })
        }
    }
    
    func acceptOrder() {
        print("ORDER ACCEPTED")
    }
    func declineOrder() {
        print("ORDER DENIED")
    }
    func markOrderAsReady() {
        print("ORDER IS READY")
    }
    func markOrderAsDone() {
        print("ORDER IS DONE")
    }
}
