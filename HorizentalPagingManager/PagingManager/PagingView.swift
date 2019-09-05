//
//  PagingView.swift
//  HorizentalPagingManeger
//
//  Created by Abdulrahman Qasem on 9/5/19.
//  Copyright © 2019 Imagine Technologies. All rights reserved.
//

import UIKit

protocol HorizontalPagingDelegate {
    func slideViews() -> [UIView]
}


class PagingView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var contentView: UIView!
    
    var delegate:HorizontalPagingDelegate?{
        didSet{
            reloadView()
        }
    }
    var enableScaleAnimation:Bool = false
    
    var showHorizontalIndicator:Bool = false{
        didSet  {
           scrollView.showsHorizontalScrollIndicator = showHorizontalIndicator
        }
    }
    
    var showPagingControl:Bool = false{
        didSet  {
            pageControl.isHidden = !showPagingControl
        }
    }
    
    
    
    private var slides:[UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInitializer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         viewInitializer()
    }
    
     func viewInitializer() {
        Bundle(for: self.classForCoder).loadNibNamed("PagingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth ,.flexibleHeight]
        scrollView.delegate = self
    }
    
    func setPagingControlColor(currentColor:UIColor ,othersColor:UIColor ) {
        pageControl.currentPageIndicatorTintColor = currentColor
        pageControl.pageIndicatorTintColor = othersColor
    }
    
    
   private func reloadView() {
        slides = delegate?.slideViews() ?? []
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        setupSlideScrollView(slides: slides)
        self.bringSubviewToFront(pageControl)
    }
    
    func setupSlideScrollView(slides : [UIView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(slides.count), height: self.frame.height)
        scrollView.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: self.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
}

extension PagingView : UIScrollViewDelegate  {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/self.frame.width)
        pageControl.currentPage = Int(pageIndex)
        if enableScaleAnimation{
            let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width
            let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
            
            let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
            
            var percent = percentageHorizontalOffset * CGFloat(slides.count)
            let currentIndex = Int(percent)
            percent -= CGFloat(currentIndex)
            if currentIndex < slides.count - 1 &&  currentIndex >= 0{
                if currentIndex > 0 {
                    slides[currentIndex - 1].transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                slides[currentIndex].transform = CGAffineTransform(scaleX: (1-percent), y: (1-percent))
                slides[currentIndex + 1].transform = CGAffineTransform(scaleX: percent, y: percent)
                
            }
        }
        
    }
}

