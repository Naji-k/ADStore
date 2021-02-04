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


}
extension AdsListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsListTableViewCell") as! AdsListTableViewCell
        
        let item = items[indexPath.row]
        if let adsImagePath = item.adsImages?.randomElement() {
//            cell.adsImage.NKPlaceholderImage(image: UIImage(named: "bmw"), imageView: cell.adsImage, imgUrl: adsImagePath) { (image) in
//                cell.adsImage.image = image
//            }
            cell.adsImage.loadImageUsingCacheWithUrlString(adsImagePath)
        } else {
            cell.adsImage.image = UIImage(named: "adpost")
        }
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
