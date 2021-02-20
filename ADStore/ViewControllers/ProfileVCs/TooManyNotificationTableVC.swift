//
//  TooManyNotificationTableVC.swift
//  ADStore
//
//  Created by Naji Kanounji on 2/16/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit

class TooManyNotificationTableVC: UITableViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var firstOptionLabel: UILabel!
    enum DeleteBecause {
        case notification, notWorking
    }
    var deleteBecause: DeleteBecause?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch deleteBecause {
        case .notification:
            self.titleLabel.text = "Too many communication from us?"
            self.detailLabel.text = "To receive fewer emails or push notifications, you can change your notification settings"
            self.firstOptionLabel.text = "Edit notification settings"
        case .notWorking:
            self.titleLabel.text = "Facing issues with the app?"
            self.detailLabel.text = "Feel free to report any issues that you'r facing with the ADStore app. We'll do our best to fix them!"
            self.firstOptionLabel.text = "Report issues with the app"
        default:
            return
        }
//        self.titleLabel.text = "Facing issues with the app?"
//        self.detailLabel.text = "Feel free to report any issues that you'r facing with the ADStore app. We'll do our best to fix them!"
//        self.firstOptionLabel.text = "Report issues with the app"

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white // Works!
            headerView.backgroundColor = .white
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case .init(row: 0, section: 0):
            switch deleteBecause {
            case .notification:
                print("edit notification setting")
                let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationTableVC") as! NotificationTableVC
                navigationController?.pushViewController(vc, animated: true)
            case .notWorking:
                let vc = storyboard?.instantiateViewController(withIdentifier: "SendFeedbackViewController") as! SendFeedbackViewController
                present(vc, animated: true, completion: nil)
            default:
                return
            }
            print("edit notification setting")
        case .init(row: 0, section: 1):  //continue with deletion
            let vc = storyboard?.instantiateViewController(withIdentifier: "AboutToDeleteVC") as! AboutToDeleteVC
            navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }

}
