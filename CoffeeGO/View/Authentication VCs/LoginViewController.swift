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
        
        bindUI()
    }

    func bindUI() {
        emailTextField.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        
        viewModel.isValid.map { $0 }.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
    }

    func routeToVC(role: Roles) { // TODO: USER AND CAR OWNER ROUTING
        let dashboardVC = UIStoryboard(name: Storyboard.dashboardStoryboard, bundle: nil).instantiateViewController(withIdentifier: ID.dashboardTabBarID) as! UITabBarController
        let carOwnerVC = UIStoryboard(name: Storyboard.carOwnerStoryboard, bundle: nil).instantiateViewController(withIdentifier: ID.carOwnerTabBarID) as! UITabBarController
    
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
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(carOwnerVC)
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

