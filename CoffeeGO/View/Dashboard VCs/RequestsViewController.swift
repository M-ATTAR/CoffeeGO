//
//  AdminsViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 12/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class RequestsViewController: UIViewController {
    
    let viewModel = RequestsViewModel()
    let bag = DisposeBag()
    var loadingAlert = UIAlertController()
    
    @IBOutlet weak var RequestsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.subToFirebase()
        
        RequestsTableView.register(UINib(nibName: "RequestsCell", bundle: nil), forCellReuseIdentifier: "RequestCell")
        RequestsTableView.backgroundColor = .clear
        RequestsTableView.allowsSelection = false
        
        loadingAlert = self.loadingMessage("Loading...")
        
        subToProcess()
        subToBadgeNumber()
        
        bindTableData()
        
        viewModel.getRequests()
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
    func subToBadgeNumber() {
        viewModel.badgeNumber.subscribe { badgeNumber in
            
            if let badgeNumber = badgeNumber.element {
                
                self.tabBarController?.tabBar.items?[1].badgeValue = badgeNumber > 0 ? "\(badgeNumber)" : nil
                
            } else {
                self.tabBarController?.tabBar.items?[1].badgeValue = nil
            }
        }.disposed(by: bag)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModel.getAdminsPS()
//        viewModel.getRequests()
    }
}


extension RequestsViewController {
    func bindTableData() {
        // Bind articles to table.
        viewModel.reqSubject.bind(to: RequestsTableView.rx.items(cellIdentifier: "RequestCell", cellType: RequestsCell.self)) { row, request, cell in
            
            cell.request = request
            
            cell.declineButtonTapped = {
                self.present(self.loadingAlert, animated: true) {
                    self.viewModel.respondToRequest(isAccepted: false, request: request)
                }
            }
            cell.acceptButtonTapped = {
                self.present(self.loadingAlert, animated: true) {
                    self.viewModel.respondToRequest(isAccepted: true, request: request)
                }
            }
            
        }.disposed(by: bag)
    }
}
