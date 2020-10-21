//
//  AdsConditionTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/21/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class AdsConditionTableViewCell: UITableViewCell {

    @IBOutlet weak var adsConditionLabel: UILabel!
    @IBOutlet weak var adsCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
