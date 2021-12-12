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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
//        configureUI()
        
        bindUI()
    }
    
//    func configureUI() {
//
//        registerButton.backgroundColor = K.lightBrown
//        registerButton.layer.cornerRadius = 10
//        registerButton.setTitleColor(K.darkBrown , for: .normal)
//
//        forgotPasswordButton.backgroundColor = K.lightBrown
//        forgotPasswordButton.layer.cornerRadius = 10
//        forgotPasswordButton.setTitleColor(K.darkBrown , for: .normal)
//
//        loginButton.setTitleColor(K.darkBrown, for: .normal)
//        loginButton.layer.cornerRadius = 10
//        loginButton.backgroundColor = K.lightBrown
//    }
    
    func bindUI() {
        emailTextField.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        
        viewModel.isValid.map { $0 }.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
    }

    func routeToVC(role: Roles) { // TODO: USER AND CAR OWNER ROUTING
        let dashboardVC = UIStoryboard(name: K.dashboardStoryboard, bundle: nil).instantiateViewController(withIdentifier: K.dashboardTabBarID) as! UITabBarController
    
        switch role {

        case .admin: // Go To Admin TabController
            print("SUCCESS")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(dashboardVC)
        case .user: // Go To User TabController
//            self.navigationController?.pushViewController(vc, animated: true)
            print("user")
        case .carOwner: // Go To Car Owner Tab Controller
//            self.navigationController?.pushViewController(vc, animated: true)
            print("car owner")
        }

    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let loading = self.loadingMessage("Signing in...")
        present(loading, animated: true)
        
        viewModel.signInTraits(email: emailTextField.text!, password: passwordTextField.text!).subscribe {
            switch $0 {
                
            case .success(let role):
                self.routeToVC(role: role)
            case .failure(let error):
                self.errorAlert(title: "Something Unexpected Happened", message: error.localizedDescription, buttonTitle: "OK")
            }
            loading.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
    
}

