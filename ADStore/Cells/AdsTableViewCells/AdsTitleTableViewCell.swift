//
//  AdsTitleTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/21/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class AdsTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var adsTitle: UILabel!
    @IBOutlet weak var adsPrice: UILabel!
    @IBOutlet weak var adsDateOfPost: UILabel!
    @IBOutlet weak var adsLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
