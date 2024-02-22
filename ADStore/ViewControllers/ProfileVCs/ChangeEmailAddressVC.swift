//
//  CheckPassVC.swift
//  ADStore
//
//  Created by Naji Kanounji on 2/16/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit
import Firebase

class CheckPassVC: UIViewController {
  
    var callback : ((Bool)->())?
    let currentUser = Auth.auth().currentUser
    
    @IBOutlet weak var mainVIew: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var passTextField: UITextField!
    var verified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        self.baseView!.addGestureRecognizer(tap)
        
        mainVIew.layer.cornerRadius = 20
        Utilities.styleFilledButton(okBtn)
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        callback?(verified)
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction.init(title: "Done", style: .default, handler: nil)
        alert.addAction(done)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func okBtnPressed(_ sender: Any) {
        checkPassword(email: (currentUser?.email)!, currentPassword: passTextField.text!) { (error) in
            if error != nil {
                self.showAlert(title: "Error", message: error!.localizedDescription)
            } else {
                
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismissVC()
    }
    @objc func dismissVC () {
        self.dismiss(animated: true, completion: nil)
    }
    func checkPassword(email: String, currentPassword: String, completion: @escaping (Error?) -> Void) {
          let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        self.currentUser?.reauthenticate(with: credential, completion: { (result, error) in
              if let error = error {
                  completion(error)
              } else {
                //correct pass
                self.verified = true
                self.dismissVC()
              }
          })
      }
}

class ChangeEmailAddressVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var newEmailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        newEmailTextField.addUnderline()
        Utilities.styleFilledButton(saveBtn)
        newEmailTextField.delegate = self
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    private func changeEmail() {
        if let user = Auth.auth().currentUser {
            
            // User re-authenticated.
            user.updateEmail(to: newEmailTextField.text!) { (error) in
                if error != nil {
                    self.showAlert(title: "Error" , message: error!.localizedDescription)
                } else {
                    self.showAlert(title: "Success" , message: "Email changed successfully.")
                }
            }
        }
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        self.changeEmail()
    }
}
