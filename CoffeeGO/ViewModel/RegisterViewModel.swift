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
    
    let firstName = BehaviorRelay<String>(value: "")
    let lastName = BehaviorRelay<String>(value: "")
    let phoneNumber = BehaviorRelay<String>(value: "")
    let email    = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    let confirmPassword = BehaviorRelay<String>(value: "")
    
    let isValidCred: Observable<Bool>
    let isValidInfo: Observable<Bool>
    let isValid: Observable<Bool>
    
    init() {
        isValidCred = Observable.combineLatest( self.email.asObservable(), self.password.asObservable(), self.confirmPassword.asObservable()) { (email, password, confirmPassword) in
            return email.isValidEmail() && password.isValidPassword() && (password == confirmPassword)
        }
        isValidInfo = Observable.combineLatest(self.firstName.asObservable(), self.lastName.asObservable(), self.phoneNumber.asObservable()) { (fName, lName, phNumber) in
            return fName != "" && lName != "" && phNumber != "" && phNumber.isValidPhoneNumber()
        }
        isValid = Observable.combineLatest( self.isValidCred.asObservable(), self.isValidInfo.asObservable()) { (cred, info) in
            return cred && info
        }
//        isValid = Observable.combineLatest( self.email.asObservable(), self.password.asObservable(), self.confirmPassword.asObservable()) { (email, password, confirmPassword) in
//            return email.isValidEmail() && password.isValidPassword() && (password == confirmPassword)
//        }
    }
    
    func register(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Error?) -> ()) {
        firebaseAuth.signUp(email: email, password: password) { _, error in
            if error == nil {
                self.verify()
                self.firebaseAuth.setDisplayName(firstName: firstName, lastName: lastName) { error in
                    completion(error)
                }
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
