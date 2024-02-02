//
//  FavoritesViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 8/19/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var likedDataKeys: NSMutableArray {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.likedDataKeys
    }
    var memes: [Ads] {
        
        return appDelegate.getAdsData() // access data
    }
    var items: [Ads] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(likedDataKeys)
        
        if likedDataKeys.count != 0 {
            for i in likedDataKeys {
                let ss = memes.filter({$0.id! == i as! String})
                items.append(contentsOf: ss)
                
            }
            let newVC = UIStoryboard.init(name: "Home", bundle: .none).instantiateViewController(withIdentifier: "AdsListTableViewController") as! AdsListTableViewController
            newVC.items = items
            //            newVC.modalPresentationStyle = .fullScreen
            newVC.navigationItem.setHidesBackButton(true, animated: true)
            navigationController?.pushViewController(newVC, animated: true)
            
        } else {
            return
        }
        
        print(items)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        items = []
    }
    
    
}
