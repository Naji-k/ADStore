//
//  AdsImagesTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/21/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class AdsImagesTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var images = ["bmw","bmw","bmw","bmw","bmw"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
print("ss")

        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        for i in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(i)
            frame.size = scrollView.frame.size
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: images[i])
            self.scrollView.addSubview(imageView)
            
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
        
        scrollView.delegate = self
        scrollViewDidEndDecelerating(scrollView)
        pageController.numberOfPages = images.count
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.size.width
        pageController.currentPage = Int(page)
    }
}
