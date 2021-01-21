//
//  UITextField-extension.swift
//  ADStore
//
//  Created by Naji Kanounji on 1/18/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//


import UIKit
//add image to textField by coding
extension UITextField {

enum Direction {
    case Left
    case Right
}

// add image to textfield
    func withImage(direction: Direction, image: UIImage, imageTintColor: UIColor, colorSeparator: UIColor, colorBorder: UIColor, mainViewColor: UIColor){
    let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
    mainView.layer.cornerRadius = 5

    let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
    view.backgroundColor = mainViewColor
    view.clipsToBounds = true
    view.layer.cornerRadius = 5
    view.layer.borderWidth = CGFloat(0.5)
    view.layer.borderColor = colorBorder.cgColor
    mainView.addSubview(view)

    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
        imageView.tintColor = imageTintColor
    view.addSubview(imageView)

    let seperatorView = UIView()
    seperatorView.backgroundColor = colorSeparator
    mainView.addSubview(seperatorView)

    if(Direction.Left == direction){ // image left
        seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 45)
        self.leftViewMode = .always
        self.leftView = mainView
    } else { // image right
        seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: 45)
        self.rightViewMode = .always
        self.rightView = mainView
    }

    self.layer.borderColor = colorBorder.cgColor
    self.layer.borderWidth = CGFloat(0.5)
    self.layer.cornerRadius = 5
    }
    
    /*
     Use :
     if let myImage = UIImage(named: "my_image"){
         textfield.withImage(direction: .Left, image: myImage, colorSeparator: UIColor.orange, colorBorder: UIColor.black)
     }
     */
    
     func showHidePassword(_ textField: UITextField, _ showHideButton: UIButton?) {
        
        showHideButton?.setImage(UIImage(named: "eye"), for: .normal)

        showHideButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        showHideButton?.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        showHideButton?.addTarget(self, action: #selector(showPass(_:)), for: .touchUpInside)
        textField.rightViewMode = .always
        textField.rightView = showHideButton
        
    }
    @objc func showPass( _ showHideButton: UIButton) {
        self.isSecureTextEntry.toggle()
        self.isSecureTextEntry ? showHideButton.setImage(UIImage(named: "eye"), for: .normal) : showHideButton.setImage(UIImage(named: "eye.slash"), for: .normal)
    }
 
    //to use
    //  var showHideButton: UIButton? = UIButton(type: .custom)
    //textfield.showHidePassword....
    
}
