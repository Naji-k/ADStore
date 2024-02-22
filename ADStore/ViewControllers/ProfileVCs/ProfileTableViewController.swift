//
//  ProfileTableViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 2/8/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit
import Firebase
import StoreKit


class ProfileTableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var sendFeedBackCell: UITableViewCell!
    @IBOutlet weak var rateUsCell: UITableViewCell!
    @IBOutlet weak var logOutCell: UITableViewCell!
    @IBOutlet weak var notificationSettingLebel: UILabel!
    
    var user: User? {
        self.appDelegate.currentUser ?? Utilities.fetchUserInfo()
    }
    var memes: [Ads] {
        return appDelegate.getAdsData() // access data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        user = self.appDelegate.currentUser
        sendFeedBackCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        rateUsCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        logOutCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameLabel.text = user?.userFName
        emailLabel.text = user?.userEmail
        profilePic.NKPlaceholderImage(image: UIImage(named: "person.circle.fill"), imageView: profilePic, imgUrl: user?.profileImageUrl) { (image) in
            self.profilePic.image = image
        }
        
    }

        
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController


         navController.modalTransitionStyle = .coverVertical
         self.present(navController, animated: true, completion: nil)
    }

    func rateApp() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/") else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

        } else {
            UIApplication.shared.openURL(url)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: //Ads
            return 1
        case 1: //Setting
            return 4
        case 2: //About
            return 3
        case 3: //log out
            return 3
        default:
          return 1
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case .init(row: 0, section: 0):
            print("my Ads")
            let newVC = UIStoryboard.init(name: "Home", bundle:.main).instantiateViewController(withIdentifier: "AdsListTableViewController") as! AdsListTableViewController
            let items = memes.filter({$0.userId == user!.id })
            newVC.items = items
            newVC.navigationItem.title = "My Ads"
            navigationController?.pushViewController(newVC, animated: true)
            
        case .init(row: 0, section: 1):
            print("notification")
            let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationTableVC") as! NotificationTableVC
            navigationController?.pushViewController(vc, animated: true)
        case .init(row: 1, section: 1):
            print("connected")
        case .init(row: 2, section: 1):
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        case .init(row: 3, section: 1):
            print("account setting")
            let vc = storyboard?.instantiateViewController(withIdentifier: "AccountSettingTableViewController") as! AccountSettingTableViewController
            navigationController?.pushViewController(vc, animated: true)
            
        case .init(row: 0, section: 2):
            print("terms of services")
        case .init(row: 1, section: 2):
            print("privacy")
        case .init(row: 2, section: 2):
            print("Licenses")
        case .init(row: 0, section: 3):
            print("send feed-back")
            let vc = storyboard?.instantiateViewController(withIdentifier: "SendFeedbackViewController") as! SendFeedbackViewController
            self.present(vc, animated: true, completion: nil)
            
        case .init(row: 1, section: 3):
            rateApp()
        case .init(row: 2, section: 3):
            do {
              try Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                Switcher.updateRootVC()
            } catch let signOutError as NSError {
                self.presentAlert(message: "Error signing out: \(signOutError)", title: "Error!", dismissVC: false)
            }
        default:
            print("default")
        }
        
    }


}
