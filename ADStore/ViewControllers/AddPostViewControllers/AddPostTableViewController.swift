//
//  TableViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/11/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Photos
import MapKit
import CoreLocation

class AddPostTableViewController: UITableViewController, TLPhotosPickerViewControllerDelegate, UITextFieldDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let userDefault = UserDefaults.standard
    var selectedAssets = [TLPHAsset]()
    var imageArray = [UIImage]()
    var imageCount: Int = 6
    let descriptionLimit = 120
    var adsLocation: SelectedLocation?
    
    var labels = ["①", "②", "③", "④", "⑤", "⑥"]
    
    var currentUser: User {
        self.appDelegate.currentUser!
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var conditionTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var countingLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var price: UITextField!
    
    fileprivate let pickerView = ToolbarPickerView()
    fileprivate let conditionsArray = ["-select-", "New", "Used-Like New", "Used"]
    
    @objc func cancel() {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        userDefault.set(nil, forKey: "selectedCategory")
        self.countingLabel.text = "\(descriptionLimit)"
        self.categoryTextField.addTarget(self, action: #selector(self.openListPickerVC(_:)), for: UIControl.Event.editingDidBegin)
        self.locationTextField.addTarget(self, action: #selector(self.openLocationView), for: UIControl.Event.editingDidBegin)
        self.descriptionTextView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        self.conditionTextField.inputView = self.pickerView
        self.conditionTextField.inputAccessoryView = self.pickerView.toolbar
        //ToolBarPickerView Delegate
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.toolbarDelegate = self
        self.pickerView.reloadAllComponents()
        self.categoryTextField.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(pressDoneBtn))
        
        drawTextView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tableView.reloadData()
    }
    @objc func openListPickerVC(_ sender: UIButton) {
        print("categoryPressed")
        categoryTextField.resignFirstResponder()
        let vc : CategoryListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryListViewController") as! CategoryListViewController
        
        vc.callback = { newValue in
            self.categoryTextField.text = newValue
            print("categoryTextField= ", newValue)
        }
        self.present(vc, animated: true, completion: nil)
    }
//    MARK: - find location
    @objc func openLocationView() {
        locationTextField.resignFirstResponder()
        let vc: LocationSearchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationSearchVC") as! LocationSearchVC
        vc.callback = { location in
            self.locationTextField.text = location.name
            self.adsLocation = location
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    private func drawTextView () {
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = .lightGray
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        descriptionTextView.clipsToBounds = true
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
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("clicked")
            break
        default:
            view.endEditing(true)
        }
    }
    
    
    //MARK: - PostURLSession
    private func makeViaAPIRequest (imagesPath: [String] ,completion: @escaping (Bool, APIError?) -> Void) {
        let today = Date()
        let randomID = Int.random(in: 1...10000)
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .medium
        let createdDate = formatter1.string(from: today)
        
        let newAds = Ads(id: String(randomID), adsTitle: titleTextField.text!, adsDes: descriptionTextView.text, adsDate: createdDate, userId: currentUser.id!, adsPrice: price.text! + " $", adsCondition: conditionTextField.text!, adsCategory: categoryTextField.text!, adsImages: imagesPath, latitude: adsLocation!.lat , longitude: adsLocation!.long, location: locationTextField.text!)
        
        let postRequest = APIRequest(endpoint: "ads")
        postRequest.genericPostRequest(body: newAds, response: Ads.self) { result in
            switch result {
            case .success(let newAds):
                completion(true, nil)
                print("\(newAds)was been send")
            case.failure(let error):
                completion(false, error)
                print("\(error.localizedDescription) occurred")
            }
        }
    }
    
    
    @objc func pressDoneBtn () {
        //check if fields is empty..
        let emptyFields = Utilities.checkEmptyField([titleTextField, conditionTextField, categoryTextField, price, locationTextField])
        if emptyFields != nil {
            presentAlert(message: emptyFields!, title: "Error!", dismissVC: false)
        } else {
            PostNewAds()
        }
    }
    
    
    private func PostNewAds() {
        var uploadedImagePaths = [String]()
        guard !imageArray.isEmpty else {
            //adding ads without image
            self.makeViaAPIRequest(imagesPath: [""]) { success, error in
                DispatchQueue.main.async {
                    self.handleResponse(success: success, error: error)
                }
            }
            return
        }
        presentAlert(message: "Please wait...", title: "Loading", dismissVC: false)
        let group = DispatchGroup()
        for image in 1..<imageArray.count {
            group.enter()
            FirebaseHelper.uploadImageToFirebaseStorage(image: imageArray[image], child: "ads-images") { imagePath in
                if let path = imagePath {
                    uploadedImagePaths.append(path)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.dismissLoadingAlert {
                self.makeViaAPIRequest(imagesPath: uploadedImagePaths) { success, error in
                    self.handleResponse(success: success, error: error)
                }
            }
        }
    }
    
    private func handleResponse(success: Bool, error: APIError?) {
        let title = success ? "Success" : "Failed!"
        var message = "Your Ads added successfully"
        if !success {
            if let error = error {
                message = String(describing: error)
            }
        }
        presentAlert(message: message, title: title, dismissVC: true)
    }
        
    //check if there alert(loading images...) or not
    private func dismissLoadingAlert(completion: @escaping () -> Void) {
        if let loadingAlert = presentedViewController as? UIAlertController {
            loadingAlert.dismiss(animated: true, completion: completion)
        } else {
            completion()
        }
    }
}
// MARK: - Collection view data source

extension AddPostTableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count == 0 {
            return imageCount
          } else {
              return imageArray.count
          }
     }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostCollectionViewCell", for: indexPath) as! AddPostCollectionViewCell
        //1st Cell AddCamera image
        if indexPath.row == 0 {
            cell.imageFrame.image = UIImage(named: "add camera")
            cell.imageNumberLabel.text = ""
            cell.imageView.image = nil
        } else {
            if imageArray.count != 0 {
                cell.imageNumberLabel.text = labels[(indexPath.item) - 1]
                cell.imageFrame.image = nil
                cell.imageView.image = imageArray[indexPath.item]
            } else {
                cell.imageFrame.image = UIImage(named: "imagePlaceHolder")
                cell.imageNumberLabel.text = labels[(indexPath.row) - 1]
                cell.imageView.image = nil
            }
        }
        return cell
    }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            addImages()
        default:
            print("\(indexPath.item)")
            
        }
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let screenSize = UIScreen.main.bounds
         let itemWidth = (screenSize.width - 46) / 3
//         let itemHeight = (collectionView.frame.height - 10) / 2
         //        return CGSize(width: 100, height: 100)
        return CGSize(width: itemWidth, height: collectionView.frame.height)
         
     }
    
}
//    MARK: - TLPhotosPickerDelegate
extension AddPostTableViewController: TLPhotosPickerLogDelegate {
    
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets

        self.imageArray = getImageArray(assets: selectedAssets)
        self.imageArray.insert(UIImage(named: "add camera")!, at: 0)
        //Update UI
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
//        DispatchQueue.main.async(execute: {
//            if let index = IndexPath(row: 0, section: 0) as? IndexPath {
//                if let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddPostAddImagesTableViewCell", for: index) as? AddPostAddImagesTableViewCell {
//                    self.tableView.reloadData()
//                    cell.collectionReloadData()
//
//                }
//            }
//        })
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
//    MARK: - PickerView Delegate
extension AddPostTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return conditionsArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.conditionsArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.conditionTextField.text = self.conditionsArray[row]
    }
}
extension AddPostTableViewController: ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.conditionTextField.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.conditionTextField.text = nil
        self.conditionTextField.resignFirstResponder()
    }
    
}
//MARK: - TextView Delegate
extension AddPostTableViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = .lightGray
        }
    }
    
    //countingLabel limit
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count < descriptionLimit {
            self.countingLabel.textColor = .black
        } else {
            self.countingLabel.textColor = .red
        }
        self.countingLabel.text = "\(descriptionLimit - textView.text.count)"
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= descriptionLimit    // 10 Limit Value
    }
}
