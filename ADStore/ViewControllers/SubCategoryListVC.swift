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
//    var matched = [Ads]()
    
//    var url = "http://localhost:3000/Ads"
    var url = "http://192.168.1.208:3000/Ads"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        needCallBack ? print("callBack") : fetchAds()
                
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if needCallBack == true {
            callback?(selected ?? "" )
        }
        
//        print(callback)
    }
    
    func fetchAds() {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    print("No data or statusCode not OK")
                    return
            }
            let decoder = JSONDecoder()
            do {
                let post = try decoder.decode([Ads].self, from: data)
                print("data\(data.count)")
                DispatchQueue.main.async {
                    self.appDelegate.passAdsData(post)
                }
                print("Ads count: \(self.memes.count)")
            } catch _ as NSError {
                print("error")
                return
            }
        }
        task.resume()
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
            
//        let selected = items[indexPath.row].subName ?? ""
            self.selected = item
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//            self.dismiss(animated: true, completion: nil)
        } else {
      
        let newVC = storyboard?.instantiateViewController(withIdentifier: "AdsListTableViewController") as! AdsListTableViewController
            let test = memes.filter({($0.adsCategory?.contains(item))!})
            
//        memes.forEach { (ads) in
//            if (ads.adsCategory == item) {
//                matched.append(ads)
//            }
//        }
            newVC.items = test
        navigationController?.pushViewController(newVC, animated: true)
        
        }
    }
    
}
