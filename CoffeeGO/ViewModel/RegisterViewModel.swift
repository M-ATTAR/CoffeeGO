//
//  RegisterViewModel.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 08/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
    
    let firebaseAuth = FirebaseAuthManager()
    
    let email    = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let confirmPassword = BehaviorRelay<String>(value: "")
    
    let isValid: Observable<Bool>
    
    init() {
        isValid = Observable.combineLatest(self.email.asObservable(), self.password.asObservable(), self.confirmPassword.asObservable()) { (email, password, confirmPassword) in
            return email.isValidEmail() && password.isValidPassword() && (password == confirmPassword)
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Error?) -> ()) {
        firebaseAuth.signUp(email: email, password: password) { _, error in
            if error == nil {
                self.verify()
            }
            completion(error)
        }
    }
    
    func verify() {
        firebaseAuth.verifyUser { error in
            print(error?.localizedDescription ?? "whatever")
        }
    }
}
