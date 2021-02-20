//
//  AddPostAddImagesTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/26/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class AddPostAddImagesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var imageCount: Int = 6
    var images = [UIImage]()
    var labels = ["①", "②", "③", "④", "⑤", "⑥"]
    @IBOutlet weak var collectionView: UICollectionView!

    
    func collectionReloadData(){
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//     var viewController2 = AddPostViewController()
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count == 0 {
            return imageCount
        } else {
            return images.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostCollectionViewCell", for: indexPath) as! AddPostCollectionViewCell
        
        if indexPath.row == 0 {
            cell.imageFrame.image = UIImage(named: "add camera")
            cell.imageNumberLabel.text = ""
            cell.imageView.image = nil
        } else {
            
            if images.count != 0 {
                cell.imageNumberLabel.text = labels[(indexPath.item) - 1]
                cell.imageFrame.image = nil
                cell.imageView.image = images[indexPath.item]
            } else {
                cell.imageFrame.image = UIImage(named: "imagePlaceHolder")
                   cell.imageNumberLabel.text = labels[(indexPath.row) - 1]
                   cell.imageView.image = nil
            }
            
        }
 
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let itemWidth = (screenSize.width - 46) / 3
        let itemHeight = (collectionView.frame.height - 10) / 2
//        return CGSize(width: 100, height: 100)
        return CGSize(width: itemWidth, height: itemWidth)

    }

    
}
