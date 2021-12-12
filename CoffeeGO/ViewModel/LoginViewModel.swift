//
//  LoginViewModel.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 08/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    private let firebaseAuth = FirebaseAuthManager()
    private let disposeBag = DisposeBag()
    
    // For Validation
    let email    = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    let isValid: Observable<Bool>
    
    init() {
        isValid = Observable.combineLatest(self.email.asObservable(), self.password.asObservable()) { (email, password) in
            return email.isValidEmail() && password.isValidPassword()
        }
    }
    
    private func signIn(email: String, password: String, completion: @escaping (Error?) -> ()) {
        firebaseAuth.signIn(email: email, password: password) { _, error in
            completion(error)
        }
    }
    
    
    private func getRole(uid: String, _ completion: @escaping (Roles) -> ()) {
        firebaseAuth.getRole(uid: uid).subscribe(onNext: { role in
            completion(role)
        }).disposed(by: disposeBag)
    }
    
    func signInRX(email: String, password: String) -> Observable<Roles> {
        return Observable.create { observer in
            self.firebaseAuth.signIn(email: email, password: password) { authResult, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    self.getRole(uid: authResult!.user.uid) { role in
                        observer.onNext(role)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func signInTraits(email: String, password: String) -> Single<Roles> {
        return Single.create { single in
            let disposable = Disposables.create()
            
            self.firebaseAuth.signIn(email: email, password: password) { authResult, error in
                if let error = error {
                    single(.failure(error))
                } else {
                    self.getRole(uid: authResult!.user.uid) { role in
                        UserDefaults.standard.set(role.rawValue, forKey: "role")
                        UserDefaults.standard.set(authResult!.user.uid, forKey: "userID")
                        single(.success(role))
                    }
                }
            }
            
            return disposable
        }
    }
}

