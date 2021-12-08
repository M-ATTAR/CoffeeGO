//
//  UserAuth.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 08/12/2021.
//

import Foundation
import FirebaseAuth

struct FirebaseAuthManager {
    
    private let firebaseAuth = Auth.auth()
    
    func signIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
          completion(authResult, error)
        }
    }
    
    func signOut(completion: @escaping (Error?) -> () ) {
        do {
            try firebaseAuth.signOut()
            completion(nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(signOutError)
        }
    }
    
    func signUp() {
        
    }
}
