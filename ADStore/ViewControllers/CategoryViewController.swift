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

    var url = "http://192.168.1.18:3000/Category"

    let slider = ["place-ads-here", "place-ads-here", "place-ads-here", "place-ads-here"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var sliderTimer: Timer?


    var memes: [Category] {
        return appDelegate.getCategoryData() // access data
    }
    
    var currentUser: User? {
        self.appDelegate.currentUser
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.fetchUserInfo()
        
//        fetchCategory()
        startSliderTimer()
        fetchCategory(endpoints: "Category")
        
        //tested logout button
//        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Log out", style: .plain, target: self, action: #selector(logOut))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sliderTimer?.invalidate()
    }

    func fetchCategory(endpoints: String) {
        let getRequest = APIRequest(endpoint: endpoints)
        getRequest.genericGetRequest( response: [Category].self) { result in
            switch result {
            case.success(let res):
                print("category count ", res.count)
                self.appDelegate.passCategoryData(res)
                self.collectionView.reloadData()
            case .failure(let error):
                print("error ", error)
            }
        }
    }
}
//MARK: -  Category delegate and datasource
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
        cell.shadowDecorate()
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 200)
    }
    
//    MARK: - Custom Header: Slider
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CategoryHeader", for: indexPath) as! CategoryHeader
        
        headerView.frame = CGRect(x: 0 , y: 0, width: self.collectionView.frame.width, height: 200)
        
        headerView.scrollView.frame = CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: headerView.scrollView.frame.height)
        headerView.configure()
                
        for i in 0..<slider.count {
            
            frame.origin.x = headerView.scrollView.frame.size.width * CGFloat(i)
            frame.size = headerView.scrollView.frame.size
            let imageView = UIImageView(frame: frame)
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: slider[i])
            headerView.scrollView.addSubview(imageView)
            
        }
        headerView.scrollView.contentSize = CGSize(width:self.collectionView.frame.width * CGFloat(slider.count), height:headerView.scrollView.frame.height)
        
        headerView.pageController.currentPage = 0
        headerView.pageController.numberOfPages = (slider.count)
        
        
        return headerView
        
    }
    
    func startSliderTimer() {
        sliderTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
    }

    
    @objc func scrollToNextItem() {
        guard let headerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? CategoryHeader else {
            return
        }

        let contentWidth = headerView.scrollView.contentSize.width
        let currentOffset = headerView.scrollView.contentOffset.x
        let singleItemWidth = headerView.scrollView.frame.width
        let nextOffset = currentOffset + singleItemWidth

        if nextOffset < contentWidth {
            headerView.scrollView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: true)
            let nextPage = Int(nextOffset / singleItemWidth)
            headerView.pageController.currentPage = nextPage
        } else {
            // If it's the last item, scroll back to the first item
            headerView.scrollView.setContentOffset(.zero, animated: true)
            headerView.pageController.currentPage = 0
        }
    }

}
extension UICollectionViewCell {
    func shadowDecorate() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
//        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.layer.masksToBounds = true
    
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius

    }
}
