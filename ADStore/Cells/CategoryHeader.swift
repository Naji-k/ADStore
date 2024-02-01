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
    
    var headerTapAction: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func headerTapped(sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        let index = Int(point.x / self.frame.width)
        headerTapAction?(index)
    }
    
}
extension CategoryHeader: UIScrollViewDelegate {
    
    func configure() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollViewDidScroll(scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let pageFraction = scrollView.contentOffset.x / pageWidth
        pageController.currentPage = Int(round(pageFraction))

    }
}
