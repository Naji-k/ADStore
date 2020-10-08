//
//  PodViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/5/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Photos

class PodViewController: UIViewController, TLPhotosPickerViewControllerDelegate {
    
    var imagesArray = [UIImage]()
    var selectedAssets = [TLPHAsset]()
    
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    @IBAction func btnPressed() {
//        let viewController = TLPhotosPickerViewController()
//        viewController.delegate = self
//        var configure = TLPhotosPickerConfigure()
//        configure.allowedVideo = false
////        configure.maxSelectedAssets = 
//        configure.numberOfColumn = 2
//        configure.mediaType = .image
//        configure.allowedLivePhotos = false
//        
//        viewController.configure = configure
//        viewController.selectedAssets = self.selectedAssets
//        viewController.logDelegate = self
//
//        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
//            
//            self?.showExceededMaximumAlert(vc: picker)
//        }
//
//        self.present(viewController, animated: true, completion: nil)
    }
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
//        getImages ()
//        getFirstSelectedImage()
        self.imagesArray = getImageArray(assets: selectedAssets)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        return true
        
    }
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        // if you want to used phasset.
        

    }
    func photoPickerDidCancel() {
        // cancel
    }
    func dismissComplete() {
        // picker viewcontroller dismiss completion
    }
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        //Custom Rules & Display
        //You can decide in which case the selection of the cell could be forbidden.
        return true
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        // exceed max selection
        self.showExceededMaximumAlert(vc: picker)

    }
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        // handle denied albums permissions case
        picker.dismiss(animated: true) {
              let alert = UIAlertController(title: "", message: "Denied albums permissions granted", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
          }
    }
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        // handle denied camera permissions case
        let alert = UIAlertController(title: "", message: "Denied camera permissions granted", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
           picker.present(alert, animated: true, completion: nil)
    }
    func showExceededMaximumAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "", message: "Exceed Maximum Number Of Selection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    func showUnsatisifiedSizeAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "Oups!", message: "The required size is: 300 x 300", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }

    
    func getImageArray(assets: [TLPHAsset]) -> [UIImage] {
        var arrayOfImages = [UIImage]()
        
        arrayOfImages = assets.map { ($0.fullResolutionImage)!}
        return arrayOfImages
        }

            
}




extension PodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PodCollectionViewCell", for: indexPath) as! PodCollectionViewCell
        let item = imagesArray[indexPath.item]
        cell.image.image = item
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let itemWidth = (screenSize.width - 36) / 3
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}
extension PodViewController: TLPhotosPickerLogDelegate {
    //For Log User Interaction
    func selectedCameraCell(picker: TLPhotosPickerViewController) {
        print("selectedCameraCell")
    }
    
    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("selectedPhoto")
    }
    
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("deselectedPhoto")
    }
    
    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {
        print("selectedAlbum")
    }
}
