//
//  AdsUserTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/21/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit
protocol UserLinksDelegate {
    func didTapOnUser(url: String)
}

class AdsUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    
    var delegate: UserLinksDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func userBtnPressed(_ sender: Any) {
        delegate?.didTapOnUser(url: "user name")
    }
}
