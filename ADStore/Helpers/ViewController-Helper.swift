//
//  ViewController-Helper.swift
// 
//
//  Created by Naji Kanounji on 12/20/23.
//

import UIKit


import UIKit

extension UIViewController {
    
    //present alert message (for error with ok button)
    func presentAlert(message: String, title: String, dismissVC: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default) { _ in
            if (dismissVC) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alertController.addAction(dismissAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        if presentedViewController == nil {
            let messageAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            messageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            present(messageAlert, animated: true, completion: nil)
        }
    }

    //alert vc with two options (YES/NO) each option could have a handler
    func askQuestionAlert(title: String , message: String, yesHandler: (() -> Void)? = nil, noHandler: (() -> Void)? = nil) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           
           let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
               yesHandler?()
           }
           
           let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
               noHandler?()
           }
           
           alertController.addAction(yesAction)
           alertController.addAction(noAction)
           
           DispatchQueue.main.async {
               self.present(alertController, animated: true)
           }
       }
    
    //activityIndicator when loading data
    func setupActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        activityIndicator.color = .gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true

        self.view.addSubview(activityIndicator)
    }
    
//    func setupNavigationBarAppearance() {
//        let appearance = UINavigationBarAppearance()
//
//        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
//        navigationController?.navigationBar.tintColor = UIColor(named: "TintGreen")
//        navigationController?.navigationBar.standardAppearance = appearance
//    }
}
