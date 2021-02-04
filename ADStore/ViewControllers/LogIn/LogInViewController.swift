//
//  LogInViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/30/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {


    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var showHideButton: UIButton? = UIButton(type: .custom)
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To auto hide keyboard when surrounding is pressed
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view!.addGestureRecognizer(tap)
        
        setUpElements()

//        registerForKeyboardNotifications()
        setupKeyboardObservers()
        // Do any additional setup after loading the view.
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
    
    
    func setUpElements() {
        // Hide the error label
//        errorLabel.alpha = 1
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        // add images to textField
        if #available(iOS 13.0, *) {
            if let email = UIImage(systemName: "envelope"), let password = UIImage(systemName: "lock") {
                emailTextField.withImage(direction: .Left, image: email, imageTintColor: .black, colorSeparator: UIColor.clear, colorBorder: UIColor.clear, mainViewColor: .clear)
                passwordTextField.withImage(direction: .Left, image: password, imageTintColor: .black, colorSeparator: .clear, colorBorder: .clear, mainViewColor: .clear)
            }
            
        } else {
            // Fallback on earlier versions
            if let email = UIImage(named: "envelope"), let password = UIImage(named: "lock"){
                emailTextField.withImage(direction: .Left, image: email, imageTintColor: .black, colorSeparator: UIColor.clear, colorBorder: UIColor.clear, mainViewColor: .clear)
                passwordTextField.withImage(direction: .Left, image: password, imageTintColor: .black, colorSeparator: .clear, colorBorder: .clear, mainViewColor: .green)
            }
        }
        passwordTextField.showHidePassword(passwordTextField, showHideButton)
        
    }
    
    private func registerForKeyboardNotifications() {
        
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillShow(_:)),
        name: UIResponder.keyboardWillShowNotification,
        object: nil
      )
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillHide(_:)),
        name: UIResponder.keyboardWillHideNotification,
        object: nil
        
      )
    }

    
    @objc private func keyboardWillShow(_ notification: Notification) {
       guard let userInfo = notification.userInfo else {
         return
       }
       guard let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
         return
       }
       guard let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
         return
       }
       guard let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
         return
       }

       let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)
       bottomConstraint.constant = keyboardHeight + 20

       UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
         self.view.layoutIfNeeded()
       }, completion: nil)
     }

    @objc private func keyboardWillHide(_ notification: Notification) {
      guard let userInfo = notification.userInfo else {
        return
      }
      guard let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
        return
      }
      guard let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
        return
      }

      let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)
      bottomConstraint.constant = 20

      UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
        self.view.layoutIfNeeded()
      }, completion: nil)
    }

    @IBAction func logInBtnPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "status")
        Switcher.updateRootVC()

    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(vc, animated: true, completion: nil)
    }
}
