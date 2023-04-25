//
//  CategoryListViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/13/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController {

    var callback : ((String)->())?

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let userDefault = UserDefaults.standard
    var memes: [Category] {
        return appDelegate.getCategoryData() // access data
    }
    var selected: String? = nil
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("didAppear")
        if selected?.isEmpty ?? false  {
            dismiss(animated: true, completion: nil)
        } else {
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        callback?(selected ?? "")
    }

}
//MARK: - TableView Delegate
extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListTableViewCell") as! CategoryListTableViewCell
        let item = memes[indexPath.row]
        cell.categoryIcon.image = UIImage(named: item.image!)
        cell.categoryName.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selected = memes[indexPath.row].name ?? ""
//        self.selected = selected
//        self.dismiss(animated: true, completion: nil)
        //should go to subCategory list
//       let itemVC = storyboard?.instantiateViewController(withIdentifier: "SubCategoryListVC") as! SubCategoryListVC
        
        let newVC = UIStoryboard.init(name: "Home", bundle: .none).instantiateViewController(withIdentifier: "SubCategoryListVC") as! SubCategoryListVC
        
        guard let item = memes[indexPath.item].subCategory else {
            print("No subCategory")
            return
        }
        newVC.items = item
        newVC.needCallBack = true
        newVC.callback = { newValue in
            self.selected = newValue
        }
        self.present(newVC, animated: true, completion: nil)
        
    }
}
