//
//  AdsListTableViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/19/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class AdsListTableViewController: UIViewController {

    var items: [Ads] = []
    
    var adsImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (items.count == 0) {
            showAlert(title: "Alert", message: "No ads here!")
        }
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
//            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
extension AdsListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsListTableViewCell") as! AdsListTableViewCell
        
        let item = items[indexPath.row]
        if let adsImagePath = item.adsImages?.last {
            cell.adsImage.NKPlaceholderImage(image: UIImage(named: "place-holder"), imageView: cell.adsImage, imgUrl: adsImagePath) { (image) in
                cell.adsImage.image = image
            }
        }
//            cell.adsImage.loadImageUsingCacheWithUrlString(adsImagePath)
//        } else {
//            cell.adsImage.image = UIImage(named: "adpost")
//        }
        cell.title.text = item.adsTitle
        cell.price.text = item.adsPrice
        cell.date.text = item.adsDate
        cell.condition.text = item.adsCondition
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "AdsViewController") as! AdsViewController
        
        vc.item = item
        
//        self.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
