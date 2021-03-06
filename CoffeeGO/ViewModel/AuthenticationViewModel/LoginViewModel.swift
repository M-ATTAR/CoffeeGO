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
    
    // TODO: For Validation - In View Controller
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
                        UserDefaults.standard.set(authResult!.user.uid, forKey: "userID")
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    
//    func signInTraits(email: String, password: String) -> Single<Roles> {
//        return Single.create { single in
//            let disposable = Disposables.create()
//
//            self.firebaseAuth.signIn(email: email, password: password) { authResult, error in
//                if let error = error {
//                    single(.failure(error))
//                } else {
//                    self.getRole(uid: authResult!.user.uid) { role in
//                        UserDefaults.standard.set(role.rawValue, forKey: "role")
//                        UserDefaults.standard.set(authResult!.user.uid, forKey: "userID")
//
//                        // To be able to create accounts and re-sign in.
//                        UserDefaults.standard.set(email, forKey: "email")
//                        UserDefaults.standard.set(password, forKey: "password")
//
//                        single(.success(role))
//                    }
//                }
//            }
//
//            return disposable
//        }
//    }
    
    func signInTraits(email: String, password: String) -> Single<Roles> {
        return Single.create { single in
            
            self.firebaseAuth.signInRX(email: email, password: password).subscribe { result in
                self.getRole(uid: result.user.uid) { role in
                    UserDefaults.standard.set(role.rawValue, forKey: "role")
                    UserDefaults.standard.set(result.user.uid, forKey: "userID")
                    
                    single(.success(role))
                }
            } onError: { error in
                single(.failure(error))
            }.disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
    
}

