//
//  DeleteAccountTableVC.swift
//  ADStore
//
//  Created by Naji Kanounji on 2/16/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit

class DeleteAccountTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: //don't want to use...
            let vc = storyboard?.instantiateViewController(withIdentifier: "DoNotWantVC") as! DoNotWantVC
            vc.reason = .doNotWant
            navigationController?.pushViewController(vc, animated: true)
            
        case 1: //another account
            let vc = storyboard?.instantiateViewController(withIdentifier: "AboutToDeleteVC") as! AboutToDeleteVC
            navigationController?.pushViewController(vc, animated: true)
            
        case 2: //too many notifications
            let vc = storyboard?.instantiateViewController(withIdentifier: "TooManyNotificationTableVC") as! TooManyNotificationTableVC
            vc.deleteBecause = .notification
            navigationController?.pushViewController(vc, animated: true)
            
        case 3: //not working properly
            let vc = storyboard?.instantiateViewController(withIdentifier: "TooManyNotificationTableVC") as! TooManyNotificationTableVC
            vc.deleteBecause = .notWorking
            navigationController?.pushViewController(vc, animated: true)
            
        case 4: //other
            let vc = storyboard?.instantiateViewController(withIdentifier: "DoNotWantVC") as! DoNotWantVC
            vc.reason = .other
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            return
        }
    }
}
