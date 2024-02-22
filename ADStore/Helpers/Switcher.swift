//
//  Switcher.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/29/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Switcher {

    static func fetchUserInfo() {
        DispatchQueue.main.async {
            guard let uid = Auth.auth().currentUser?.uid else {
                //for some reason uid = nil
                return
            }
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User(dictionary: dictionary)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.currentUser = user
                    print("user from Switcher....: ", user)
                }
                
            }, withCancel: nil)
        }
        
    }
    static func checkIfUserLogIn() {
        var rootVC : UIViewController?

        if Firebase.Auth.auth().currentUser?.uid == nil {
            rootVC = UIStoryboard(name: "LogIn", bundle: .none).instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        } else {
            fetchUserInfo()
            rootVC = UIStoryboard.init(name: "Main", bundle:.main).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC

    }
    static func updateRootVC(){
        
        let status = UserDefaults.standard.bool(forKey: "status")
        var rootVC : UIViewController?
        
        print("logIn status: \(status)")
        
        if(status == true){
            fetchUserInfo()
            rootVC = UIStoryboard.init(name: "Main", bundle:.main).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        }else{
            rootVC = UIStoryboard(name: "LogIn", bundle: .none).instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        }
        
        if let appDelegate = UIApplication.shared.windows.first {
            
        appDelegate.rootViewController = rootVC
            UIView.transition(with: appDelegate, duration: 0.5, options: [.transitionFlipFromLeft], animations: nil, completion: nil)

        }
    }
    
}
