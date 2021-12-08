//
//  RegisterViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 08/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var register: UIButton!
    
    var viewModel = RegisterViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        email.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)

        password.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        confirmPassword.rx.text.orEmpty.bind(to: viewModel.confirmPassword).disposed(by: disposeBag)
        
        viewModel.isValid.map { $0 }.bind(to: register.rx.isEnabled).disposed(by: disposeBag)
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        viewModel.register(email: email.text!, password: password.text!) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // go to verification
                
                let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
