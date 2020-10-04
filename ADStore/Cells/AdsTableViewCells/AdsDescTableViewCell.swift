//
//  AdsDescTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/21/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

protocol ExpandingCellProtocol: class {
    func updateHeightOfRow(_ cell: AdsDescTableViewCell, _ textView: UITextView)
}

class AdsDescTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    weak var cellDelegate: ExpandingCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension AdsDescTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let deletate = cellDelegate {
            deletate.updateHeightOfRow(self, descTextView)
        }
    }
}
