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


class AddPostTableViewController: UITableViewController, TLPhotosPickerViewControllerDelegate, UITextFieldDelegate {
    let userDefault = UserDefaults.standard
    var selectedAssets = [TLPHAsset]()
    var imageArray = [UIImage]()
    var imageCount: Int = 6

    var labels = ["①", "②", "③", "④", "⑤", "⑥"]

    @IBOutlet weak var collectionView: UICollectionView!

    //Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var conditionTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var countingLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var price: UITextField!
    
    fileprivate let pickerView = ToolbarPickerView()
    fileprivate let conditionsArray = ["New", "Used-Like New", "Used"]

    @objc func cancel() {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        userDefault.set(nil, forKey: "selectedCategory")
        self.categoryTextField.addTarget(self, action: #selector(self.openListPickerVC(_:)), for: UIControl.Event.editingDidBegin)

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

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(makeViaAPIRequest))
        
        drawTextView()
        
        print("imageArray: \(imageArray.count)")


    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tableView.reloadData()

    }
    @objc func openListPickerVC(_ sender: UIButton) {
        print("categoryPressed")
        let vc : CategoryListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryListViewController") as! CategoryListViewController
        
        vc.callback = { newValue in
            self.categoryTextField.text = newValue
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
        default:
            print("else")
        }
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: <#T##IndexPath#>)
//            return cell
//
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - PostURLSession
    @objc func makeViaAPIRequest () {
        let newAds = Ads(adsTitle: titleTextField.text!, adsDes: descriptionTextView.text, adsDate: "22-02-2020", adsPrice: price.text! + " $", adsCondition: conditionTextField.text!, adsCategory: categoryTextField.text!, adsImages: "bmw")
        
        let postRequest = APIRequest(endpoint: "Ads")
        postRequest.save(newAds, completion: { result in
            switch result {
            case .success(let newAds):
                print("\(newAds)was been send")
            case.failure(let error):
                print("\(error.localizedDescription) occurred")
            }
        })
    }
    
    @objc func makeAPost() {
//                let session = URLSession.shared
        let session = URLSession(configuration: .ephemeral)
        let createRequest = PostRouter.create(Ads(adsTitle: titleTextField.text!, adsDes: descriptionTextView.text!, adsDate: "22-10-2020", adsPrice: price.text!, adsCondition: conditionTextField.text!, adsCategory: categoryTextField.text!, adsImages: "bmw")).asURLRequest()
        
        let putTask = session.dataTask(with: createRequest) { data, response, error in
            // handler just shows us what we updated on json-server
            
            guard let data = data, let response = response as? HTTPURLResponse,
                response.statusCode == 201 else {
                    print("error \(error?.localizedDescription)")
                    return
            }
            
            let decoder = JSONDecoder()
            do {
                let post = try decoder.decode([Ads].self, from: data)
                // decoded data is just the Post we updated on json-server
                print(post)
            } catch let decodeError as NSError {
                print("Decoder error: \(decodeError.localizedDescription)\n")
                return
            }
        }
        putTask.resume()
        
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
        print(imageArray.count)
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
            descriptionTextView.text = ""
            descriptionTextView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Description"
            descriptionTextView.textColor = .lightGray
        }
    }
    //certain characters or grow up to certain height
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return ((descriptionTextView.text.count) > 60  && descriptionTextView.frame.height > 100) ? false : true
    }
    //countingLabel limit
    func textViewDidChange(_ textView: UITextView) {
        self.countingLabel.text = "\(60 - textView.text.count)"
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return descriptionTextView.text.count + (descriptionTextView.text.count - range.length) <= 60

    }
}
