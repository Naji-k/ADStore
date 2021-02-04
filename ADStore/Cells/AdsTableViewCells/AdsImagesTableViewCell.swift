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
        
    var count = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollViewDidScroll(scrollView)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let pagFraction = scrollView.contentOffset.x / pageWidth
        pageController.currentPage = Int(round(pagFraction))
    }
 
    @IBAction func pageControllerTapped(_ sender: UIPageControl) {
        let page: Int? = sender.currentPage
        var frame = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page ?? 0)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: true)
    }
}
