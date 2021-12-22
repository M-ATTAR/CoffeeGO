//
//  OrderDetailsViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 20/12/2021.
//

import UIKit

class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var orderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var orderView: OrderDetailsView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orderView.order = self.order
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        
//        orderViewHeight.constant = 10
//        orderVIew.layoutIfNeeded()
//        scrollView.
        print(orderView.bounds.height)
        
    }

}
