//
//  SubCategoryViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/12/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class SubCategoryListVC: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var items = [SubCategory]()
    var needCallBack = false
    var callback : ((String)->())?
    var selected: String?

    var memes: [Ads] {
        return appDelegate.getAdsData() // access data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        needCallBack ? print("callBack") : fetchAds("ads")
                
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if needCallBack == true {
            callback?(selected ?? "" )
        }
        
    }
    
    func fetchAds(_ endPoint: String) {
        let request = APIRequest(endpoint: endPoint)
        request.genericGetRequest(response: [Ads].self) { result in
            switch result {
            case .success(let ads):
                print(ads.count)
                self.appDelegate.passAdsData(ads)

            case .failure(let error):
                self.presentAlert(message: "\(error)", title: "Error!", dismissVC: false)
            }
        }
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
        guard let item = items[indexPath.row].subName else {
            print("No Ads")
            return
        }
        if needCallBack == true {
            self.selected = item
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
      
        let newVC = storyboard?.instantiateViewController(withIdentifier: "AdsListTableViewController") as! AdsListTableViewController
            let test = memes.filter({($0.adsCategory?.contains(item))!})
            
            newVC.items = test
            navigationController?.pushViewController(newVC, animated: true)
        
        }
    }
    
}
