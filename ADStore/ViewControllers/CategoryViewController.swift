//
//  ViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 8/19/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit
import Firebase

class CategoryViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

//    var url = "http://localhost:4000/category"
    var url = "http://192.168.1.208:4000/category"
//    var jsonItems: [Category] = []

    
//    private var _currentUser: User?
//    var currentUser: User? {
//        get { return _currentUser }
//        set { _currentUser = newValue}
//    }
    var memes: [Category] {
        return appDelegate.getCategoryData() // access data
    }
    
    var currentUser: User? {
        self.appDelegate.currentUser
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchUserInfo()
/*
    category localy
        items.append(CategoryLocal(id: 0, catName: "Vehicles", catImage: "icon", subCat:[SubCategory(subName: "Rent", subImage: "icon", id: 0), SubCategory(subName: "Sale", subImage: "icon", id: 1), SubCategory(subName: "parts", subImage: "icon", id: 1)]))
        items.append(CategoryLocal(id: 1, catName: "Properties", catImage: "icon", subCat: [SubCategory(subName: "Rent", subImage: "icon", id: 0)]))
        items.append(CategoryLocal(id: 2, catName: "Mobile Phones & Accessories", catImage: "icon", subCat: [SubCategory(subName: "Rent", subImage: "icon", id: 0)]))
        items.append(CategoryLocal(id: 3, catName: "Fashion & Beauty", catImage: "icon", subCat: [SubCategory(subName: "Rent", subImage: "icon", id: 0)]))
 */
        
        fetchCategory()
        
        //tested logout button
//        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Log out", style: .plain, target: self, action: #selector(logOut))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = currentUser?.userFName
    }

//    @objc func logOut() {
//    }
    /*
    func fetchUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User(dictionary: dictionary)
                    self.currentUser = user
                    DispatchQueue.main.async {
                        self.appDelegate.currentUser = user
                        print("delegate", self.appDelegate.currentUser)
                        self.userDef.set(user, forKey: "user")
                }
            }
            
        }, withCancel: nil)
    }
    */
    func fetchCategory () {
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
        guard let data = data, let response = response as? HTTPURLResponse,
            response.statusCode == 200 else {
                print("No data or statusCode not OK")
                return
            }

        let decoder = JSONDecoder()
            do {
                let post = try decoder.decode([Category].self, from: data)
                print("data\(data.count)")
//                self.jsonItems = post
                DispatchQueue.main.async {
                    self.appDelegate.passCategoryData(post)
                    self.collectionView.reloadData()
                }
                print("json count: \(self.memes.count)")
            } catch _ as NSError {
                print("error")
                return
            }
        }
        task.resume()
    }
}
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let itemWidth = (screenSize.width - 64) / 3
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        let item = memes[indexPath.item]
        cell.label.text = item.name
        cell.imageView.image = UIImage(named: item.image!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemVC = storyboard?.instantiateViewController(withIdentifier: "SubCategoryListVC") as! SubCategoryListVC
        
        guard let item = memes[indexPath.item].subCategory else {
            print("No subCategory")
            return
        }
        itemVC.items = item
        navigationController?.pushViewController(itemVC, animated: true)
    }
}

