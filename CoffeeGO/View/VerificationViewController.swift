//
//  VerificationViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 08/12/2021.
//

import UIKit

class VerificationViewModel {
    let firebaseAuth = FirebaseAuthManager()
    
    func isVerified() -> Bool {
        return firebaseAuth.isEmailVerified()
    }
}

class VerificationViewController: UIViewController {
    
    let viewModel = VerificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = viewModel.isVerified() ? UIColor.green : UIColor.red
    }
}
