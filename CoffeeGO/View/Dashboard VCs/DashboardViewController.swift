//
//  HomeViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 11/12/2021.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOutTapped(_ sender: UIButton) {
        let firebaseAuth = FirebaseAuthManager()
        firebaseAuth.signOut { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let vc = UIStoryboard(name: K.mainStoryboard, bundle: .main).instantiateViewController(withIdentifier: K.loginVCID) as! LoginViewController
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(vc)
            }
        }
    }
}
