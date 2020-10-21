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
        return appDelegate.getData() // access data
    }
    var selected: String?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        callback?(selected ?? "")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        let selected = memes[indexPath.row].name ?? ""
        self.selected = selected
        self.dismiss(animated: true, completion: nil)
    }
}
