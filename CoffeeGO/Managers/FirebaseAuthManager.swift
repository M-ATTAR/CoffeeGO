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

enum CGError: Error{
    case deleted
}
extension CGError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .deleted:
            return NSLocalizedString(
                "Your account has been deleted, Contact us for more details.",
                comment: ""
            )
        }
    }
}
class FirebaseAuthManager {
    
    let firebaseAuth = Auth.auth()
    let db = Firestore.firestore()
    var currentUser: String { return Auth.auth().currentUser?.uid ?? "" }
    
    
    func signIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
          completion(authResult, error)
        }
    }
    func signInRX(email: String, password: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            
            self.db.collection("deleted").document(email).getDocument { snapshot, error in
                if let snapshot = snapshot {
                    if snapshot.exists {
                        observer.onError(CGError.deleted)
                    }
                }
            }
            
            self.firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(authResult!)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
    func signOut(completion: @escaping (Error?) -> () ) {
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.removeObject(forKey: "role")
            UserDefaults.standard.removeObject(forKey: "userID")
//            UserDefaults.standard.removeObject(forKey: "email")
//            UserDefaults.standard.removeObject(forKey: "password")
            
            completion(nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(signOutError)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                self.addUserToDatabase(email: email)
            }
            completion(authResult, error)
          }
    }

    func setDisplayName(firstName: String, lastName: String, _ completion: @escaping (Error?) -> ()) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "\(firstName) \(lastName)"
        changeRequest?.commitChanges { error in
            completion(error)
            if error == nil {
                self.db.collection("users").document(self.currentUser).setData(["name": "\(firstName) \(lastName)"])
            }
        }
    }
    func addUserToDatabase(email: String) {
        
        db.collection("users").document(currentUser).setData([
            "role":"user",
            "email": email,
            "uid": currentUser
        ]) { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("User has been added woo")
            }
        }
    }
    func getRole(uid: String) -> Observable<Roles> {
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
                    case "carOwner":
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
    func changeRole(uid: String, to role: Roles) {
        db.collection("users").document(uid).setData(["role": role])
    }
}
