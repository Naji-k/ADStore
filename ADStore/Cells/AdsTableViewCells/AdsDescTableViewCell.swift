//
//  AdsDescTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/21/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit



class AdsDescTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    /// Custom setter so we can initialize the height of the text view
    var textString: String {
        get {
            return descTextView?.text ?? ""
        }
        set {
            if let textView = descTextView {
                textView.text = newValue
                textView.delegate?.textViewDidChange?(textView)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        descTextView.delegate = self
        descTextView.isScrollEnabled = false

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            descTextView.becomeFirstResponder()
        } else {
            descTextView.becomeFirstResponder()
        }
    }

}
