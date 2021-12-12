//
//  UserAuth.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 08/12/2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import RxSwift
import RxCocoa

class FirebaseAuthManager {
    
    let firebaseAuth = Auth.auth()
    let db = Firestore.firestore()
    var currentUser: String { return Auth.auth().currentUser?.uid ?? "" }
    
    
    func signIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
          completion(authResult, error)
        }
    }
    
    func signOut(completion: @escaping (Error?) -> () ) {
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.removeObject(forKey: "role")
            UserDefaults.standard.removeObject(forKey: "userID")
            
            completion(nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(signOutError)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                self.addUserToDatabase()
            }
            completion(authResult, error)
          }
    }
    func verifyUser(completion: @escaping (Error?) -> ()) {
        firebaseAuth.currentUser?.sendEmailVerification { error in
            completion(error)
        }
    }
    func isEmailVerified(_ completion: @escaping (Bool?, Error?) -> ()) {
        
        firebaseAuth.currentUser?.reload(completion: { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(self.firebaseAuth.currentUser?.isEmailVerified, nil)
            }
        })
    }
//    func observeUserState() {
//        handle = firebaseAuth.addStateDidChangeListener { (auth, user) in
//            print("LOOOOK ATTTT THISSSSS \(user?.isEmailVerified ?? false)")
//        }
//    }
//    func detachObservation() {
//        firebaseAuth.removeStateDidChangeListener(handle!)
//    }
    func setDisplayName(firstName: String, lastName: String, _ completion: @escaping (Error?) -> ()) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "\(firstName) \(lastName)"
        changeRequest?.commitChanges { error in
            completion(error)
        }
    }
    func addUserToDatabase() {
        
        db.collection("users").document(currentUser).setData([
            "role":"user"
        ]) { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("User has been added woo")
            }
        }
    }
    func getRole(uid: String) -> Observable<Roles> { // Should this be in FirebaseDBManager?
        return Observable.create { observer in
            self.db.collection("users").document(uid).getDocument { document, error in
                if let error = error {
                    observer.onError(error)
                }
                if let document = document, document.exists {
                    switch (document.get("role") as! String){
                    case "admin":
                        observer.onNext(.admin)
                    case "user":
                        observer.onNext(.user)
                    case "car":
                        observer.onNext(.carOwner)
                    default:
                        observer.onNext(.user)
                    }
                    observer.onCompleted()
                } else {
                    print("Document does not exist")
                }
            }
            return Disposables.create()
        }
    }
}
