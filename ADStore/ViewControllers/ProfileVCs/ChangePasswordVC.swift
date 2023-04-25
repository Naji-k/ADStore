//
//  ChangePasswordVC.swift
//  ADStore
//
//  Created by Naji Kanounji on 2/12/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var oldPassTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    let currentUser = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func viewDidLayoutSubviews() {
        setupElement()
    }
    func setupElement() {
        oldPassTextField.addUnderline()
        newPassTextField.addUnderline()
        confirmPassTextField.addUnderline()
        Utilities.styleFilledButton(saveBtn)
        
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
      func validateFields () -> String? {
            // Check that all fields are filled in
            if oldPassTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                newPassTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                confirmPassTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                
                return "Please fill in all fields."
            }
            // Check if the password is secure
            let cleanedPassword = newPassTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if Utilities.isPasswordValid(cleanedPassword) == false  {
                // Password isn't secure enough,
                return "Please make sure your password is at least 8 characters, contains a special character and a number."
                
            } else if self.confirmPassTextField.text != self.newPassTextField.text {
                // or it's not matched with confirm password
                    return "Password and Confirm password not matched!"
            }
            return nil
        }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        let fieldsValidation = validateFields()
        if fieldsValidation != nil {
            showError(fieldsValidation!)
        } else {
            self.changePassword(email: (currentUser?.email)!, currentPassword: oldPassTextField.text!, newPassword: self.newPassTextField.text!) { (error) in
                if error != nil {
                    self.showAlert(title: "Error" , message: error!.localizedDescription)
                } else {
                    self.showAlert(title: "Success" , message: "Password changed successfully.")
                }
            }
        }
//        self.dismiss(animated: true, completion: nil)
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
  func changePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        self.currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                completion(error)
            }
            else {
                self.currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    completion(error)
                })
            }
        })
    }
    
}
