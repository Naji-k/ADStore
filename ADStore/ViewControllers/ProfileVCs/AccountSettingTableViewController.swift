//
//  AccountSettingTableViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 2/12/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit

class AccountSettingTableViewController: UITableViewController {

    var baseView: UIView = {
        let window = UIApplication.shared.keyWindow!
        let view = UIView(frame: window.bounds)
        view.backgroundColor = .lightGray
        view.alpha = 0.3
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: //change password
            let vc = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.present(vc, animated: true, completion: nil)
        case 1: //change email
            let vc = storyboard?.instantiateViewController(withIdentifier: "CheckPassVC") as! CheckPassVC
            let newVC = storyboard?.instantiateViewController(withIdentifier: "ChangeEmailAddressVC") as! ChangeEmailAddressVC
            vc.callback = { result in
                if result == true {
                    self.present(newVC, animated: true, completion: nil)
                    self.baseView.removeFromSuperview()
                } else {
                    print("false")
                    self.baseView.removeFromSuperview()
                }
            }
            UIApplication.shared.keyWindow!.addSubview(baseView)

            
            self.present(vc, animated: true, completion: nil)
        case 2: //delete account
            let vc = storyboard?.instantiateViewController(withIdentifier: "DeleteAccountTableVC") as! DeleteAccountTableVC
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            return
        }
    }
    

}
