//
//  NewViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/18/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController, ImagePickerDelegate {
//    MARK: imagePicker ( add ImagePickerDelegate)
    func didSelect(image: UIImage?) {
        self.imageArray.append(image!)
        tableView.reloadData()
        DispatchQueue.main.async(execute: {
            if let index = IndexPath(row: 0, section: 0) as? IndexPath {
                if let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddPostAddImagesTableViewCell", for: index) as? AddPostAddImagesTableViewCell {
                    self.tableView.reloadData()
                    cell.collectionReloadData()
                    
//                    let path = cell.collectionView.indexPath(for: AddPostCollectionViewCell())
//                    cell.collectionView.reloadItems(at: [path!])

                }
            }
        })
           
        
        print("Done")
    }

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    var imageArray = [UIImage]()
    @IBOutlet weak var imageViewTwo: UIImageView!
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
//        imageViewTwo.isHidden = true
        self.imagePicker = ImagePicker(presentationController: self, delegate: self )
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        print("imagesArray: \(imageArray.count)")
        

    }


    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        print("oK")
//        self.dismiss(animated: true, completion: nil)
        self.imagePicker.present(from: sender)
//                addNewImage()
    }
    /**
    func addNewImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        imageViewTwo.image = image
        imageArray.append(image)
            DispatchQueue.main.async(execute: {
                if let index = IndexPath(row: 0, section: 0) as? IndexPath {
                    if let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddPostAddImagesTableViewCell", for: index) as? AddPostAddImagesTableViewCell {
                        cell.imageCell = image
                        self.tableView.reloadData()
                        cell.collectionReloadData()
                        print("update")
                    }
                }
            })
        self.dismiss(animated: true, completion: nil)
    }

    **/
}

extension AddPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPostAddImagesTableViewCell") as! AddPostAddImagesTableViewCell
        

        cell.images = imageArray
//        cell.imageCell = imageViewTwo.image ?? UIImage(named: "user")
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        addNewImage()
    }
}
