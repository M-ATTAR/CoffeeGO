//
//  OrdersViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 17/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class OrdersViewController: UIViewController {

    @IBOutlet weak var ordersTableView: UITableView!
    let viewModel = OrdersViewModel()
    let bag = DisposeBag()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var carOwnerID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ordersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ordersCell")
        navigationItem.largeTitleDisplayMode = .always

        ordersTableView.register(UINib(nibName: "OrdersCell", bundle: nil), forCellReuseIdentifier: "OrdersCell")
        ordersTableView.backgroundColor = .clear
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField

        textFieldInsideSearchBar?.textColor = .systemBackground
        textFieldInsideSearchBar?.backgroundColor = Colors.foregroundC!
        searchBar.delegate = self
        
        viewModel.subToFireBase()
        bindTableView()
        
        guard let carOwnerID = carOwnerID else {
            return
        }
        viewModel.getOrders(role: .carOwner, uid: carOwnerID)
    }
}
extension OrdersViewController: UISearchBarDelegate {
    
    func bindTableView() {
        viewModel.ordersSubject.bind(to: ordersTableView.rx.items(cellIdentifier: "OrdersCell", cellType: OrdersCell.self)) { row, order, cell in
 
            cell.order = order
            
            cell.selectionStyle = .none
        }.disposed(by: bag)
        
        ordersTableView.rx.modelSelected(Order.self).bind { order in
            // Push ViewController
            let vc = UIStoryboard(name: Storyboard.dashboardStoryboard, bundle: nil).instantiateViewController(withIdentifier: ID.orderDetailsVCID) as! OrderDetailsViewController
            vc.order = order
//            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
//            self.navigationController?.pushViewController(self.carDetailsVC, animated: true)
        }.disposed(by: bag)
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getOrders(role: .carOwner, uid: carOwnerID!)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchOrders(for: searchText)
    }
}
