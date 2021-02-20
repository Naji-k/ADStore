//
//  Don'tWantVC.swift
//  ADStore
//
//  Created by Naji Kanounji on 2/16/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit

class DoNotWantVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    enum Reason {
        case other, doNotWant
    }
    var reason: Reason?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(goToNext))
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch reason {
        case .doNotWant:
            self.titleLabel.text = "I don't want to use ADStore anymore"
            self.detailLabel.text = "Do you have any feedback for us? We would love to hear from you! (optional)"
        case .other:
            self.titleLabel.text = "Anything else you'd like to add?"
            self.detailLabel.text = "Do you have any feedback for us? We would love to hear from you! (optional)"
        default:
            return
        }
        drawTextView()
    }
    private func drawTextView () {
       textView.text = "Enter feedback.."
       textView.textColor = .lightGray
       textView.layer.cornerRadius = 5
       textView.layer.borderWidth = 1
       textView.layer.borderColor = UIColor.systemGreen.withAlphaComponent(1).cgColor
       textView.clipsToBounds = true
    }
    
    @objc func goToNext() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AboutToDeleteVC") as! AboutToDeleteVC
        navigationController?.pushViewController(vc, animated: true)
    }


}
class AboutToDeleteVC: UIViewController {
    
    @IBOutlet weak var deleteMyAccountNowBtn: UIButton!
    
    @IBOutlet weak var backToSettingsBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(deleteMyAccountNowBtn)
    }
    
    @IBAction func deleteMyAccountBtnPressed(_ sender: Any) {
        print("deleteMyAccount")
    }
    
    @IBAction func backToSettingsBtnPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
extension DoNotWantVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter feedback.."
            textView.textColor = .lightGray
        }
    }
}
