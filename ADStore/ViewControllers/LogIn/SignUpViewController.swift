//
//  SignUpViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/30/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        setUpElements()
        
    }
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    func setUpElements() {
    
        // Hide the error label
        errorLabel.alpha = 0
    
        // Style the elements
        firstNameTextField.addUnderline()
        lastNameTextField.addUnderline()
        emailTextField.addUnderline()
        passwordTextField.addUnderline()
        passwordConfirmTextField.addUnderline()
        Utilities.styleFilledButton(signUp)
        
    }
    @IBAction func signUpTapped(_ sender: Any) {
        //test
//        self.transitionToHome()
        let emptyFields = validateFields()
        
        if emptyFields != nil {
            
            // There's something wrong with the fields, show error message
            showError(emptyFields!)
        } else {
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    // There was an error creating the user
                    self.showError(err!.localizedDescription)
                    return
                } else {
                    guard let uid = result?.user.uid else { return }
                    let createdDate = Int(Date().timeIntervalSince1970)
                    let userValues = ["id": uid, "userFName": firstName + " " + lastName, "userEmail": email, "createdDate": createdDate] as [String : AnyObject]
                    // User was created successfully, now store the first name and last name
                    self.registerUserInfoToDatabaseWithUID(uid, values: userValues as [String: AnyObject])
                }
                
            }
        }
    }
    fileprivate func registerUserInfoToDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                self.showError(error.localizedDescription)
                return
            }
            _ = User(dictionary: values)
            
            self.transitionToHome()
        }
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message

    func validateFields () -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false  {
            // Password isn't secure enough,
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
            
        } else if self.passwordConfirmTextField.text != self.passwordConfirmTextField.text {
//             or it's not matched with confirm password
                return "Password and Confirm password not matched!"
        }
        return nil
    }

    func transitionToHome() {
        UserDefaults.standard.set(true, forKey: "status")
        Switcher.updateRootVC()
    }
}
