//
//  NewViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/18/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Photos

class AddPostViewController: UIViewController, ImagePickerDelegate, TLPhotosPickerViewControllerDelegate {
    //    MARK: imagePicker ( add ImagePickerDelegate)
    func didSelect(image: UIImage?) {
        self.imageArray.append(image!)
        tableView.reloadData()
        DispatchQueue.main.async(execute: {
            if let index = IndexPath(row: 0, section: 0) as? IndexPath {
                if let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddPostAddImagesTableViewCell", for: index) as? AddPostAddImagesTableViewCell {
                    self.tableView.reloadData()
                    cell.collectionReloadData()
                    
                    
                }
            }
        })
        
        
        print("Done")
    }
    
    
    @IBAction func btn(_ sender: Any) {
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    var imageArray = [UIImage]()
    
    var imagePicker: ImagePicker!
    
    var selectedAssets = [TLPHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        imageViewTwo.isHidden = true
        //        self.imagePicker = ImagePicker(presentationController: self, delegate: self )
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        tableView.estimatedRowHeight = UITableView.automaticDimension
//        tableView.rowHeight = UITableView.automaticDimension
        print("imagesArray: \(imageArray.count)")
        
    }
    
    @IBAction func cancelBtnPressed() {
        print("oK")
        self.dismiss(animated: true, completion: nil)
//        self.imagePicker.present(from: sender)

        
        
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        addImages()
    }
    
    func addImages () {
        
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        var configure = TLPhotosPickerConfigure()
        configure.allowedVideo = false
        configure.maxSelectedAssets = 5
        configure.numberOfColumn = 3
        configure.mediaType = .image
        configure.allowedLivePhotos = false
        
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        viewController.logDelegate = self
        
        
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            
            self?.showExceededMaximumAlert(vc: picker)
            
        }
        
        self.present(viewController, animated: true, completion: nil)
    }
    
}

extension AddPostViewController: UITableViewDelegate, UITableViewDataSource {
//    MARK: tableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let cell0 = tableView.dequeueReusableCell(withIdentifier: "AddPostAddImagesTableViewCell") as! AddPostAddImagesTableViewCell
            cell0.images = imageArray
            //        cell.imageCell = imageViewTwo.image ?? UIImage(named: "user")
            return cell0
        case 1:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "AddPostDescriptionTableViewCell") as! AddPostDescriptionTableViewCell
            return cell1
        default:
            print("implemnt cells")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150
        default:
            return
            UITableView.automaticDimension
            UITableView.automaticDimension

        }
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0:
//            addImages()
//        case 1:
//
//        default:
//            print("click on tableView cell")
//        }
//        addImages()
//    }
}
extension AddPostViewController: TLPhotosPickerLogDelegate {
//    MARK: TLPhotosPickerDelegate
    
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets

        self.imageArray = getImageArray(assets: selectedAssets)
        self.imageArray.insert(UIImage(named: "add camera")!, at: 0)
        //Update UI
        DispatchQueue.main.async(execute: {
            if let index = IndexPath(row: 0, section: 0) as? IndexPath {
                if let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddPostAddImagesTableViewCell", for: index) as? AddPostAddImagesTableViewCell {
                    self.tableView.reloadData()
                    cell.collectionReloadData()
                    
                }
            }
        })
        return true
        
    }
    //Convert [TLPHAsset] to [UIImage]
    func getImageArray(assets: [TLPHAsset]) -> [UIImage] {
        var arrayOfImages = [UIImage]()
        
        arrayOfImages = assets.map { ($0.fullResolutionImage)!}
        return arrayOfImages
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
