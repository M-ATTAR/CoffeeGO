//
//  ViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 08/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        email.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)

        password.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        
        viewModel.isValid.map { $0 }.bind(to: login.rx.isEnabled).disposed(by: disposeBag)
    }

    @IBAction func tapped(_ sender: UIButton) {
        
        viewModel.signIn(email: email.text!, password: password.text!) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("HOOORARRYYY")
            }
        }
        
    }
    
}

