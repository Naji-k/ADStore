//
//  AdsViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/20/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AdsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var msgTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var images = ["bmw","bmw","bmw","bmw","bmw"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    let lat = 52.7286158
    let lng = 6.4901002
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
//        tableView.tableFooterView = UIView()
    }
    
    func openMapButtonAction(latitude: Double,longitude: Double ) {
        
        let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
        let googleMaps = URL(string:"comgooglemaps://")!
        let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"
        
        var googleItem = ("Google Map", URL(string:googleURL)!)
        let wazeItem = ("Waze", URL(string:wazeURL)!)
        var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]
        
        if UIApplication.shared.canOpenURL(googleMaps) {
                installedNavigationApps.append(googleItem)
                
            } else {
                //Open in browser
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") {
                    googleItem.1 = urlDestination
                    installedNavigationApps.append(googleItem)
                }
            }
            
            if UIApplication.shared.canOpenURL(wazeItem.1){
                installedNavigationApps.append(wazeItem)
            }
            
            let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
            for app in installedNavigationApps {
                let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                    UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
                })
                alert.addAction(button)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true)
        }


    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func mapBtnPressed(_ sender: Any) {
        openMapButtonAction(latitude: lat, longitude: lng)
        
    }
    
}

extension AdsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            //images
            return 1
        case 1:
            //title & price
            return 1
        case 2:
            //user
            return 1
        case 3:
            //location
            return 1
        case 4:
            //description
            return 1
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "AdsImagesTableViewCell") as! AdsImagesTableViewCell
            
            
            return cell1
        case 1:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "AdsTitleTableViewCell") as! AdsTitleTableViewCell
            cell2.adsTitle.text = "iphone 6s 16gb"
            cell2.adsPrice.text = "100$"
            cell2.adsDateOfPost.text = "09-09"
            cell2.adsLocation.text = "Hogeveen"
            
            return cell2
        case 2:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "AdsLocationTableViewCell") as! AdsLocationTableViewCell
            cell3.showLocation2(location: CLLocation(latitude: lat, longitude: lng))
            
            
            return cell3

        case 3:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "AdsDescTableViewCell") as! AdsDescTableViewCell
            
            return cell4
        case 4:
            let cell5 = tableView.dequeueReusableCell(withIdentifier: "AdsUserTableViewCell") as! AdsUserTableViewCell
            
            return cell5
        default:
            print("Default Selected")
            
        }
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        switch indexPath.section {
//        case 0,1,2,3,4:
//            return UITableView.automaticDimension
//
//        default:
//            return 200
//        }
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.section {
//            
//        default:
//            return
//        }
//    }
    
}
//MARK: expanding cell size while typing...

extension AdsViewController: ExpandingCellProtocol {
    func updateHeightOfRow(_ cell: AdsDescTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = tableView.indexPath(for: cell) {
                tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: true)
            }
        }
    }
    
    
}
