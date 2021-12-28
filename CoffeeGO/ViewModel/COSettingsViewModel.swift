//
//  COSettingsViewModel.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 28/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

class COSettingsViewModel {
    let firebaseDB = FirebaseDBManager()
    let firebaseAuth = FirebaseAuthManager()
    
    let isActiveSubject = PublishSubject<Bool>()
    
    let bag = DisposeBag()
    
    func subToFirebase() {
        guard let uid = UserDefaults.standard.string(forKey: "userID") else {return }
        
        firebaseDB.isActiveSubject.subscribe { isActive in
            self.isActiveSubject.onNext(isActive)
        }.disposed(by: bag)
        
        firebaseDB.getStatus(uid: uid)
    }

    func signout() -> Observable<Bool> {
        return Observable.create { observer in
            
            self.firebaseAuth.signOut { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(true)
                }
            }
            return Disposables.create()
        }
    }
    
    func manageStatus(newStatus: Bool) {
        guard let uid = UserDefaults.standard.string(forKey: "userID") else {return }
        firebaseDB.manageStatus(uid: uid, newStatus: newStatus)
    }
}
