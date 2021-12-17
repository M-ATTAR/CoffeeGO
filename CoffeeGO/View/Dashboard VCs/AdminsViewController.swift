//
//  AdminsViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 12/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class AdminsViewController: UIViewController {
    
    let viewModel = AdminsViewModel()
    let bag = DisposeBag()
    var loadingAlert = UIAlertController()
    
    @IBOutlet weak var adminsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adminsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        adminsTableView.backgroundColor = .clear
        adminsTableView.allowsSelection = false
        
        loadingAlert = self.loadingMessage("Loading...")
        subToProcess()
        
        bindTableData()
    }
    
    func subToProcess() {
        viewModel.isLoading.subscribe (
            onNext: { process in
                switch(process) {
                case true:
                    self.present(self.loadingAlert, animated: true)
                case false:
                    self.loadingAlert.dismiss(animated: true)
                }
            },
            onError: { error in
                self.errorAlert(title: Constants.errorAlertTitle, message: error.localizedDescription, buttonTitle: "OK")
            }).disposed(by: bag)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAdminsPS()
    }
}


extension AdminsViewController {
    func bindTableData() {
        // Bind articles to table.
        viewModel.admins.bind(to: adminsTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, model, cell in
            
            cell.textLabel?.text = model.name
            
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .systemBrown
            
        }.disposed(by: bag)
    }
}
