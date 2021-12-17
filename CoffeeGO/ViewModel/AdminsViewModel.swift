//
//  AdminsViewModel.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 12/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

class AdminsViewModel {
    let bag = DisposeBag()
    let firebaseDB = FirebaseDBManager()
    
    let admins = PublishSubject<[Admin]>()
    let isLoading = PublishSubject<Bool>()
    
    init() {
        firebaseDB.adminsSubject.subscribe { adminsList in
            self.admins.onNext(adminsList)
            self.isLoading.onNext(false)
        } onError: { error in
//            self.admins.onError(error)
            self.isLoading.onError(error) // TODO: Separate them.
        }.disposed(by: bag)
    }
    
//    func getAdmins() {
//        process.onNext(true)
//        firebaseDB.getAdmins().subscribe { element in
//
//            switch (element) {
//
//            case .success( let adminsArray ):
//                self.admins.onNext(adminsArray)
//                self.process.onCompleted()
//            case .failure(let error):
//                self.admins.onError(error)
//                self.process.onError(error)
//            }
//        }.disposed(by: bag)
//    }
    
    func getAdminsPS() {
        isLoading.onNext(true)
        firebaseDB.getAdminsPS()
    }
}
