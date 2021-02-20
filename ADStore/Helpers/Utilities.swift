//
//  Utilities.swift
//
//  Created by Naji Kanounji on 10/22/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
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
