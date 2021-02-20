//
//  SendFeedbackViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 2/10/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit
import MessageUI


class SendFeedbackViewController: UIViewController {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var feedBackTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedBackTextView.delegate = self
        submitBtn.isEnabled = false
        drawTextView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utilities.styleFilledButton(submitBtn)
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        //try it on real device.
//        sendEmail()
    }
    private func drawTextView () {
        feedBackTextView.text = "Enter feedback.."
        feedBackTextView.textColor = .lightGray
        feedBackTextView.layer.cornerRadius = 5
        feedBackTextView.layer.borderWidth = 0.5
        feedBackTextView.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.5).cgColor
        feedBackTextView.clipsToBounds = true
    }
}

extension SendFeedbackViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
            submitBtn.isEnabled = true
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter feedback.."
            textView.textColor = .lightGray
            submitBtn.isEnabled = false
        }
    }
}

extension SendFeedbackViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["you@yoursite.com"])
            mail.setMessageBody("<p>\(String(describing: feedBackTextView.text))</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            print("error sending mail")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
