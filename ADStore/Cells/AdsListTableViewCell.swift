//
//  AdsListTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/19/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class AdsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adsImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
