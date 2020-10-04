//
//  AddPostAddImagesTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/26/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class AddPostAddImagesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var imageCount: Int = 1
    var images = [UIImage]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageCell: UIImage!

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


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostCollectionViewCell", for: indexPath) as! AddPostCollectionViewCell
        if  images.count != 0 {
            let item = images[indexPath.item]
            cell.imageView.image = item as! UIImage
//            cell.imageView.image = imageCell
        
            return cell
        } else {
//            cell.imageView.image = imageCell
            cell.imageView.image = UIImage(named: "bmw")
            return cell
        }
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let itemWidth = (screenSize.width - 46) / 3
        
        return CGSize(width: 100, height: 100)

    }
    
    /**
    func addNewImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        
//        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            //            imageView.image = pickedImage
            //            imageView.contentMode = .scaleAspectFill
//            imageViewTwo.image = pickedImage
            images.append(pickedImage)
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    **/
}
