//
//  AdsViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/20/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class AdsViewController: UIViewController {
//    var isAdsFav = UserDefaults.standard.bool(forKey: "isAdsFav")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var likedDataKeys: NSMutableArray {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.likedDataKeys
    }
    var memes: [Ads] {
        return appDelegate.getAdsData() // access data
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var msgTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var adsUser: User?
    
    var item: Ads?
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    let lat = 52.7286158
    let lng = 6.4901002
    
    var bottom: CGFloat {
        if UIScreen.main.bounds.size.height > 736 {
            return 75
        } else {
            return 250
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        msgTextField.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view!.addGestureRecognizer(tap)

        
        
        setupKeyboardObservers()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let likeBtn = UIBarButtonItem(image: UIImage(named: "heart.fill"), style: .plain, target: self, action: #selector(favoriteBtnPressed))
        
        if likedDataKeys.contains(item!.id!) {
            likeBtn.tintColor = .red
        } else {
            likeBtn.tintColor = .lightGray
        }
        navigationItem.rightBarButtonItem = likeBtn
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
        fetchUserInfo()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    @objc func favoriteBtnPressed() {

        if likedDataKeys.contains(item!.id!) {   //liked
//            let index = likedDataKeys.index(of: item!)
            likedDataKeys.remove(item!.id!)
//            item!.checked.toggle()
            print("dislike")
            navigationItem.rightBarButtonItem?.tintColor = .lightGray

        } else {
            likedDataKeys.add(item!.id!)    //dislike
            print("liked")
            navigationItem.rightBarButtonItem?.tintColor = .red
        }
        print(likedDataKeys.count)
        
    }
    
    fileprivate func fetchUserInfo() {
        guard let uid = item?.userId else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.adsUser = user
            }
        }, withCancel: nil)
    }
    
    func openMapButtonAction(latitude: Double,longitude: Double ) {
        
        let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
        let googleMaps = URL(string:"comgooglemaps://")!
        let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"
        
        var googleItem = ("Google Map", URL(string:googleURL)!)
        let wazeItem = ("Waze", URL(string:wazeURL)!)
        var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]
        
        if UIApplication.shared.canOpenURL(googleMaps) {
            installedNavigationApps.append(googleItem)
            
        } else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") {
                googleItem.1 = urlDestination
                installedNavigationApps.append(googleItem)
            }
        }
        
        if UIApplication.shared.canOpenURL(wazeItem.1){
            installedNavigationApps.append(wazeItem)
        }
        
        let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
        for app in installedNavigationApps {
            let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    
    @IBAction func sendBtnPressed() {
        print(msgTextField.text)
        msgTextField.text = ""
        msgTextField.resignFirstResponder()
    }
    
    
    @IBAction func mapBtnPressed(_ sender: Any) {
        openMapButtonAction(latitude: lat, longitude: lng)
        
    }
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        //Hides keyboard
        view.endEditing(true)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
            //            scrollView.contentInset = contentInsets
            //            scrollView.scrollIndicatorInsets = contentInsets
            
            UIView.animate(withDuration: keyboardDuration!, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
            UIView.animate(withDuration: keyboardDuration!, animations: {
                self.view.layoutIfNeeded()
            })
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            // reset back the content inset to zero after keyboard is gone
            //            scrollView.contentInset = contentInsets
            //            scrollView.scrollIndicatorInsets = contentInsets
            
        }
    }
}
//MARK: - tableViewDelegate
extension AdsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0...5: return 1
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0: //image
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "AdsImagesTableViewCell") as! AdsImagesTableViewCell
            
            cell1.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: cell1.scrollView.frame.height)
            //local Images..
            //            for i in 0..<images.count {
            //                frame.origin.x = cell1.scrollView.frame.size.width * CGFloat(i)
            //                frame.size = cell1.scrollView.frame.size
            //                let imageView = UIImageView(frame: frame)
            //                imageView.image = UIImage(named: images[i])
            //                cell1.scrollView.addSubview(imageView)
            //
            //            }
            //on host images..
            for i in 0..<(item?.adsImages?.count)! {
                frame.origin.x = cell1.scrollView.frame.size.width * CGFloat(i)
                frame.size = cell1.scrollView.frame.size
                let imageView = UIImageView(frame: frame)
                imageView.contentMode = .scaleAspectFit
                
                imageView.NKPlaceholderImage(image: UIImage(named: "bmw"), imageView: imageView, imgUrl: (item?.adsImages?[i])!) { (image) in
                    imageView.image = image
                    
                }
                cell1.scrollView.addSubview(imageView)
            }
            
            cell1.scrollView.contentSize = CGSize(width:self.view.frame.width * CGFloat((item?.adsImages?.count)!), height:cell1.scrollView.frame.height)
            
            cell1.pageController.currentPage = 0
            cell1.pageController.numberOfPages = (item?.adsImages?.count)!
            
            
            return cell1
            
        case 1: //title & price
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "AdsTitleTableViewCell") as! AdsTitleTableViewCell
            cell2.adsTitle.text = item?.adsTitle
            cell2.adsPrice.text = item?.adsPrice
            cell2.adsDateOfPost.text = item?.adsDate
            cell2.adsLocation.text = "Hogeveen"
            
            return cell2
        case 2: //location
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "AdsLocationTableViewCell") as! AdsLocationTableViewCell
            cell3.showLocation2(location: CLLocation(latitude: lat, longitude: lng))
            
            
            return cell3
            
        case 3: //condition & category
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "AdsConditionTableViewCell") as! AdsConditionTableViewCell
            cell4.adsCategoryLabel.text = item?.adsCategory
            cell4.adsConditionLabel.text = item?.adsCondition
            return cell4
            
        case 4: //description
            
            let cell5 = tableView.dequeueReusableCell(withIdentifier: "AdsDescTableViewCell") as! AdsDescTableViewCell
            cell5.cellDelegate = self
            cell5.descTextView.text = item?.adsDes
           /* """
            Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. naji naji naji I am trying to expand
            Ask sd hard nsd the show d
            Add bass
            Add had
            Add jade
            Add jade
            """ */
            
            return cell5
        case 5:
            let cell6 = tableView.dequeueReusableCell(withIdentifier: "AdsUserTableViewCell") as! AdsUserTableViewCell
            
            cell6.delegate = self
            
            if let createdDate = adsUser?.createdDate {
                //get Date from NSNumber and calculate to get created from.. 1 months..
                let time = TimeInterval(truncating: createdDate)
                let diffComponents = Calendar.current.dateComponents([.day, .hour], from: Date(timeIntervalSince1970: time), to: Date())
                let days = diffComponents.day
                let hour = diffComponents.hour
                cell6.createdDateLabel.text = "\(days?.description ?? "") days, \(hour?.description ?? "") hours"
                
            }
            cell6.userBtn.titleLabel?.text = adsUser?.userFName
            
            
            let imageView = UIImageView(image: UIImage(named: "person.circle.fill"))
            imageView.NKPlaceholderImage(image: UIImage(named: "at"), imageView: imageView, imgUrl: adsUser?.profileImageUrl) { (image) in
                imageView.image = image
            }
            cell6.userBtn.setTitle(adsUser?.userFName, for: .normal)
            cell6.userProfileImage.NKPlaceholderImage(image: UIImage(named: "person.circle.fill"), imageView: cell6.userProfileImage, imgUrl: adsUser?.profileImageUrl) { (image) in
                cell6.userProfileImage.image = image
            }
            
            return cell6
        default:
            print("Default Selected")
            
        }
        return cell
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        switch indexPath.section {
    //        case 0,1,2,3,4:
    //            return UITableView.automaticDimension
    //
    //        default:
    //            return 200
    //        }
    //    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        switch indexPath.section {
    //
    //        default:
    //            return
    //        }
    //    }
}
//MARK: - click on user delegate..
extension AdsViewController: UserLinksDelegate {
    func didTapOnUser(url: String) {
        print(url)
        let newVC = storyboard?.instantiateViewController(withIdentifier: "AdsListTableViewController") as! AdsListTableViewController
        let items = memes.filter({$0.userId == adsUser?.id })
        newVC.items = items
        newVC.navigationItem.title = adsUser?.userFName
        navigationController?.pushViewController(newVC, animated: true)

    }
    
}
//MARK: -  expanding cell size while typing...

extension AdsViewController: ExpandingCellProtocol {
    func updateHeightOfRow(_ cell: AdsDescTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = tableView.indexPath(for: cell) {
                tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: true)
            }
        }
    }
}
//MARK: - textFieldDelegate..
extension AdsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendBtnPressed()
        return true
    }
}
