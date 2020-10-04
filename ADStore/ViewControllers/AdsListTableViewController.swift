//
//  AdsListTableViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/19/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class AdsListTableViewController: UIViewController {

    var items = [Ads]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
extension AdsListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsListTableViewCell") as! AdsListTableViewCell
        
        let item = items[indexPath.row]
        cell.adsImage.image = UIImage(named: item.adsImages!)
        cell.title.text = item.adsTitle
        cell.price.text = item.adsPrice
        cell.date.text = item.adsDate
        cell.condition.text = item.adsCondition
        
        return cell
    }
    
    
}
