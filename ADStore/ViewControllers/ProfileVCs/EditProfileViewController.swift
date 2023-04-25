//
//  ProfileViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 8/19/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var changePhoto: UIButton!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    enum ProfilePicStatus {
        case changed, deleted, nothing, changeUserName
    }
    var profilePicStatus: ProfilePicStatus?
    
    var user: User {
        self.appDelegate.currentUser!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.delegate = self
        nameLabel.addTarget(self, action: #selector(textFieldDidChange(_:)),
        for: .editingChanged)
        Utilities.customButtonColors(saveBtn, enableColor: UIColor(named: "Color.Tint.Green")!, disableColor: .lightGray, cornerRadius: 25, borderWidth: 1, tintColor: .white)
        self.saveBtn.isEnabled = false
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = user.userFName
        profilePic.NKPlaceholderImage(image: UIImage(named: "person.circle.fill"), imageView: profilePic, imgUrl: user.profileImageUrl) { (image) in
            self.profilePic.image = image
        }
        
    }
    @objc func dismissKeyboard() {
        //Hides keyboard
         view.endEditing(true)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        profilePicStatus = .changeUserName
        if textField.text == user.userFName {
            self.saveBtn.isEnabled = false
        } else {
            self.saveBtn.isEnabled = true
        }
    }

    
    @IBAction func changePhotoBtnPressed(_ sender: Any) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        let changePhoto = UIAlertAction(title: "Change Photo", style: .default) { (action) in
            self.handleSelectProfileImageView()
        }
        let deletePhoto = UIAlertAction(title: "Delete Photo", style: .destructive) { (action) in
            print("delete")
            self.profilePicStatus = .deleted
            self.profilePic.image = UIImage(named: "person.circle.fill")
            self.saveBtn.isEnabled = true
        }
        actionSheetController.addAction(changePhoto)
        actionSheetController.addAction(deletePhoto)
        actionSheetController.addAction(cancelAction)
        actionSheetController.popoverPresentationController?.sourceView = view // works for both iPhone & iPad
        present(actionSheetController, animated: true) {
            print("option menu presented")
        }
        
    }
    fileprivate func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    fileprivate func uploadImageToFirestore(imageView: UIImageView) {
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        if let profileImage = imageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
            storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                if let error = err {
                    print(error)
                    return
                }
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let url = url?.absoluteString else { return }
                    print(url)
                    
                    let userValues = ["userFName": self.nameLabel.text as AnyObject, "profileImageUrl": url as AnyObject] as [String : AnyObject]
                    self.updateUserIntoDatabaseWithUID(self.user.id!, values: userValues)
                }
            })
        }
    }
    fileprivate func deleteProfilePic() {
        
        let storage = Storage.storage()
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(self.user.id!)
        guard let imageUrl = self.user.profileImageUrl else {return}
        let storageRef = storage.reference(forURL: imageUrl)
        //Removes link from database then remove image from storage
        let userValues = ["id": self.user.id! as AnyObject, "userFName": self.nameLabel.text as AnyObject, "userEmail": self.user.userEmail as AnyObject] as [String : AnyObject]
        
        userReference.setValue(userValues) { (error, ref) in
            if let error = error {
                print(error)
                return
            } else {
//                let user = User(dictionary: userValues)
//                self.appDelegate.currentUser = user
                storageRef.delete { (error) in
                    if let error = error {
                        print(error)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
            }
        }
    }
    
    fileprivate func updateUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            let user = User(dictionary: values)
        }
        
        self.dismiss(animated: true) {
            
        }
    }
    
    fileprivate func updateUserInfoOnFirebase() {
        switch profilePicStatus {
        case .changed:
            uploadImageToFirestore(imageView: profilePic)
        case .nothing:
            let userValues = ["userFName": self.nameLabel.text as AnyObject] as [String : AnyObject]
            self.updateUserIntoDatabaseWithUID(self.user.id!, values: userValues)
        case .deleted:
            self.deleteProfilePic()
        case .changeUserName:
            let userValues = ["userFName": self.nameLabel.text as AnyObject] as [String : AnyObject]
            self.updateUserIntoDatabaseWithUID(self.user.id!, values: userValues)
        default:
            return
        }
        
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        updateUserInfoOnFirebase()
        appDelegate.currentUser = Utilities.fetchUserInfo()
//        fetchUserInfo()
    }
    
//    fileprivate func fetchUserInfo() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                let user = User(dictionary: dictionary)
//
//                self.appDelegate.currentUser = user
//            }
//        }, withCancel: nil)
//    }
}

//MARK: - add/change profile picture
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profilePic.image = selectedImage
            profilePicStatus = .changed
            self.saveBtn.isEnabled = true
        } else {
            profilePicStatus = .nothing
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
