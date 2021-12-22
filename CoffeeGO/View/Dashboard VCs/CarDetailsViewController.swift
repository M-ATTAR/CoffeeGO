//
//  CarDetailsViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 16/12/2021.
//

import UIKit
import MapKit

protocol ModalPresentation {
    func modalPresentationEnded()
}

class CarDetailsViewController: UIViewController {
    
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var revLabel: UILabel!
    
    @IBOutlet weak var revView: UIView!
    @IBOutlet weak var ordersView: UIView!
    
    @IBOutlet weak var ordersLabel: UILabel!
    
    var delegate: ModalPresentation?
    
    var carOwner: CarOwner?
    var cordinate = CLLocationCoordinate2D()
    var address: String = ""
    var viewModel = DashboardViewModel()
    
    @IBOutlet weak var phNumberButton: CGButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete this car", style: .plain, target: self, action: #selector(deleteButtonTapped))
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        locationMapView.layer.cornerRadius = 15
        revView.layer.cornerRadius = 10
        ordersView.layer.cornerRadius = 10
        
        revView.addGestureRecognizer(tap2)
        ordersView.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let vc = UIStoryboard(name: Storyboard.dashboardStoryboard, bundle: nil).instantiateViewController(withIdentifier: ID.ordersVCID) as! OrdersViewController
        
        vc.carOwnerID = carOwner?.uid
//        vc.modalPresentationStyle = .overFullScreen
//        present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        carNameLabel.text = "\(carOwner?.name ?? "N/A")'s Car"
        ordersLabel.text = "\(carOwner?.totalOrders ?? 0)"
        phNumberButton.setTitle(carOwner?.phoneNumber, for: .normal)
        revLabel.text = "$\(carOwner?.totalRevenue ?? 0.0)"
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "circle.fill")?.withTintColor( (carOwner?.isActive ?? false) ? .systemGreen : .systemRed)
        
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        fullString.append(NSAttributedString(string: " \(carOwner?.isActive ?? false ? "Active" : "Inactive" )"))
        statusLabel.attributedText = fullString
        
        
        if let location = carOwner?.location {
            cordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = cordinate
            
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: cordinate.latitude, longitude: cordinate.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error -> Void in
                
                // Place details
                guard let placeMark = placemarks?.first else { return }
                
                // Street address
                if let street = placeMark.thoroughfare {
                    self.address += "\(street) "
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                    self.address += city
                }
                // Town
                if let town = placeMark.locality {
                    self.address += (" " + town)
                }
            
                annotation.subtitle = self.address
            })
            
            annotation.title = carNameLabel.text
            
            
            locationMapView.setRegion(MKCoordinateRegion(center: cordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
            locationMapView.addAnnotation(annotation)
        }
    }
    
    
    @IBAction func showMapsTapped(_ sender: CGButton) {
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: cordinate.latitude, longitude: cordinate.longitude)))
        destination.name = carNameLabel.text
                
        MKMapItem.openMaps(
          with: [destination],
          launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        )
    }
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        viewModel.deleteCar(uid: carOwner?.uid ?? "")
        dismiss(animated: true) {
            self.delegate?.modalPresentationEnded()
        }
    }
    
    @IBAction func phNumberButtonTapped(_ sender: CGButton) {
        guard let number = URL(string: "tel://" + ((carOwner?.phoneNumber))!) else { return }
        UIApplication.shared.open(number)
    }
}
