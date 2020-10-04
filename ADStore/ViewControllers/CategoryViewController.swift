//
//  ViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 8/19/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
//    var items: [CategoryLocal] = []
    var url = "http://localhost:4000/category"
    var jsonItems: [Category] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
/*
    category localy
        items.append(CategoryLocal(id: 0, catName: "Vehicles", catImage: "icon", subCat:[SubCategory(subName: "Rent", subImage: "icon", id: 0), SubCategory(subName: "Sale", subImage: "icon", id: 1), SubCategory(subName: "parts", subImage: "icon", id: 1)]))
        items.append(CategoryLocal(id: 1, catName: "Properties", catImage: "icon", subCat: [SubCategory(subName: "Rent", subImage: "icon", id: 0)]))
        items.append(CategoryLocal(id: 2, catName: "Mobile Phones & Accessories", catImage: "icon", subCat: [SubCategory(subName: "Rent", subImage: "icon", id: 0)]))
        items.append(CategoryLocal(id: 3, catName: "Fashion & Beauty", catImage: "icon", subCat: [SubCategory(subName: "Rent", subImage: "icon", id: 0)]))
 */
        fetchCategory()
    }


    func fetchCategory () {
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) {(data,response,error) in
        guard let data = data, let response = response as? HTTPURLResponse,
            response.statusCode == 200 else {
                print("No data or statusCode not OK")
                return
            }

        let decoder = JSONDecoder()
            do {
                let post = try decoder.decode([Category].self, from: data)
                print("data\(data.count)")
                self.jsonItems = post
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                print("json count: \(self.jsonItems.count)")
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
        let itemWidth = (screenSize.width - 46) / 3
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsonItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        let item = jsonItems[indexPath.item]
        cell.label.text = item.name
        cell.imageView.image = UIImage(named: item.image!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemVC = storyboard?.instantiateViewController(withIdentifier: "SubCategoryListVC") as! SubCategoryListVC
        
        guard let item = jsonItems[indexPath.item].subCategory else {
            print("No subCategory")
            return
        }
        itemVC.items = item
        navigationController?.pushViewController(itemVC, animated: true)
    }
}

