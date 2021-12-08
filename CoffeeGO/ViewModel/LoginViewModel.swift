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
    
    let firebaseAuth = FirebaseAuthManager()
    
    let email    = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    let isValid: Observable<Bool>
    
    init() {
        isValid = Observable.combineLatest(self.email.asObservable(), self.password.asObservable()) { (email, password) in
            return email.isValidEmail() && password.isValidPassword()
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> ()) {
        firebaseAuth.signIn(email: email, password: password) { _, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
}

