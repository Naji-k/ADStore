//
//  CategoryHeader.swift
//  ADStore
//
//  Created by Naji Kanounji on 3/4/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit

class CategoryHeader: UICollectionReusableView {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
}
extension CategoryHeader: UIScrollViewDelegate {
    
    func configure() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollViewDidScroll(scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let pagFraction = scrollView.contentOffset.x / pageWidth
        pageController.currentPage = Int(round(pagFraction))

    }
}
