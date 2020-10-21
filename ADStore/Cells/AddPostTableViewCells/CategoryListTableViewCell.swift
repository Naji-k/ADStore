//
//  CategoryListTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/13/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryIcon: UIImageView!
    
    
    @IBOutlet weak var categoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
