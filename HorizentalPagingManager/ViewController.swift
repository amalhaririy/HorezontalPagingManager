//
//  ViewController.swift
//  HorizentalPagingManeger
//
//  Created by Abdulrahman on 9/5/19.
//  Copyright © 2019 Imagine Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pagingView: PagingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        pagingView.delegate = self
        pagingView.enableScaleAnimation = true
        pagingView.pageControl.pageIndicatorTintColor = .red
         pagingView.pageControl.isHidden = true
      
    }

}

extension ViewController : HorizontalPagingDelegate {
    func slideViews() -> [UIView] {
        var views:[UIView] = []
        let colors:[UIColor] = [.red , .blue , .yellow , .green,.gray , .black , .purple , .brown]
        for i in colors.indices{
            let view = UIView()
            view.backgroundColor = colors[i]
            views.append(view)
        }
        return views
    }
    
    
}
