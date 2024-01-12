//
//  Utilities.swift
//
//  Created by Naji Kanounji on 10/22/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Utilities {
    //checker for empty TextFields (you can specify which one is empty or just return a general msg
   static func checkEmptyField (_ textFields : [UITextField]) -> String? {
        var message: String?
        for i in textFields {
            if i.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                message =  "Please fill in all fields."
            }
        }
        return message
    }
    
    static func fetchUserInfo() -> User? {
        var user: User?
         guard let uid = Auth.auth().currentUser?.uid else {
             //for some reason uid = nil
             return nil
         }
         Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                 if let dictionary = snapshot.value as? [String: AnyObject] {
                      user = User(dictionary: dictionary)
                     DispatchQueue.main.async {
                         let appDelegate = UIApplication.shared.delegate as! AppDelegate
                         appDelegate.currentUser = user
                         print("called from utilities")
                 }
             }
             
         }, withCancel: nil)
        return user
     
     }
    
    static func fetchUserIDInfo(userID: String, completion: @escaping(User?) -> Void) {
        var user: User?
        print("fetch userID ", userID)
         Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                 if let dictionary = snapshot.value as? [String: AnyObject] {
                      user = User(dictionary: dictionary)
                     
             }
             completion(user)
         }, withCancel: nil)
    }
    
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        let width = textfield.frame.size.width
        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 2, width: width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        textfield.setNeedsLayout()
        
    }
    static func changeDisableButtonColor(button: UIButton, color: UIColor) {
        let rect = CGRect(x: 0.0, y: 0.0, width: button.frame.width, height: button.frame.height)
        UIGraphicsBeginImageContext(rect.size)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        button.setBackgroundImage(image, for: .disabled)
    }
    
    static func styleFilledButton(_ button:UIButton) {
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func customButtonColors(_ button: UIButton, enableColor: UIColor, disableColor: UIColor, cornerRadius: CGFloat, borderWidth: Int, tintColor: UIColor) {
        button.backgroundColor = enableColor
        button.layer.cornerRadius = cornerRadius
        button.tintColor = tintColor
        
        let rect = CGRect(x: 0.0, y: 0.0, width: button.frame.width, height: button.frame.height)
        let rectPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(rectPath)
        context?.setFillColor(disableColor.cgColor)
        context?.closePath()
        context?.fillPath()
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        button.setBackgroundImage(image, for: .disabled)
        
        

    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
 public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
 public func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}
