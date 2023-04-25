//
//  MessageTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 2/22/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit

class MessagesControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var mainTaxtLabel: UILabel!
    @IBOutlet weak var DetailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
