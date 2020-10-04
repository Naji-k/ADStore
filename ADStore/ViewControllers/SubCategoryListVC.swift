//
//  SubCategoryViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/12/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class SubCategoryListVC: UIViewController {
    
    var items = [SubCategory]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}

extension SubCategoryListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCell") as! SubCategoryTableViewCell
        let item = items[indexPath.row]
        cell.subLabel.text = item.subName
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = storyboard?.instantiateViewController(withIdentifier: "AdsListTableViewController") as! AdsListTableViewController
        guard let item = items[indexPath.item].ads else {
            print("No Ads")
            return
        }
        newVC.items = item
        navigationController?.pushViewController(newVC, animated: true)
        
    }
    
}
