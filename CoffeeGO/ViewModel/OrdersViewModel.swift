//
//  OrdersViewModel.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 17/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

class OrdersViewModel {
    let firebaseDB = FirebaseDBManager()
    let bag = DisposeBag()
    let ordersSubject = PublishSubject<[Order]>()
    
    var ordersArray = [Order]()
    
    func subToFireBase() {
        
        firebaseDB.ordersSubject.subscribe { orders in
            self.ordersSubject.onNext(orders)
            self.ordersArray = orders
        } onError: { error in
            print(error.localizedDescription)
        }.disposed(by: bag)

    }
    
    func getOrders(role: Roles, uid: String) {
        firebaseDB.getOrders(role: role, uid: uid)
    }
    func searchOrders(for text: String) {
        ordersSubject.onNext( ordersArray.filter {$0.orderID!.contains(text) } )
    }
}
