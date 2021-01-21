//
//  Switcher.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/29/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        let status = UserDefaults.standard.bool(forKey: "status")
        var rootVC : UIViewController?
        

            print("logIn status: \(status)")
        

        if(status == true){

            rootVC = UIStoryboard.init(name: "Main", bundle:.main).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        }else{
            rootVC = UIStoryboard(name: "LogIn", bundle: .none).instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC

                
        
    }
    
}
