//
//  AdminsViewModel.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 12/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

class RequestsViewModel {
    let bag = DisposeBag()
    let firebaseDB = FirebaseDBManager()
    
    let reqSubject = PublishSubject<[Request]>()
    let isLoading = PublishSubject<Bool>()
    let badgeNumber = PublishSubject<Int>()

    func subToFirebase() {
        firebaseDB.requestsSubject.subscribe { requests in
            self.reqSubject.onNext(requests)
            self.badgeNumber.onNext(requests.count)
            self.isLoading.onNext(false)
        } onError: { error in
            self.isLoading.onError(error)
        }.disposed(by: bag)

    }
    
    func getRequests() {
        isLoading.onNext(true)
        firebaseDB.getRequests()
    }
    func respondToRequest(isAccepted: Bool, request: Request) {
        switch isAccepted {
        case true:
            self.firebaseDB.acceptRequest(request: request)
        case false:
            self.firebaseDB.declineRequest(request: request)
        }
    }
}
