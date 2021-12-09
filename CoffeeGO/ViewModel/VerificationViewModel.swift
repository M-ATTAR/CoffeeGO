//
//  VerificationViewModel.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 09/12/2021.
//

import Foundation
import FirebaseAuth

class VerificationViewModel {
    let firebaseAuth = FirebaseAuthManager()
    
//    func isVerified() -> Bool {
//        return firebaseAuth.isEmailVerified()
//    }
    func signOut(_ completion: @escaping (Error?) -> () ) {
        firebaseAuth.signOut { error in
            completion(error)
        }
    }
//    func observeUserState() {
//        firebaseAuth.observeUserState()
//    }
//    func detachObservation() {
//        firebaseAuth.detachObservation()
//    }
    func printUserData() {
        print(Auth.auth().currentUser?.displayName)
        print(Auth.auth().currentUser?.email)
    }
}
