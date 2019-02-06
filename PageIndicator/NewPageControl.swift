//
//  NewPageControl.swift
//  PageIndicator
//
//  Created by Emanuela Ferrara on 29/01/2019.
//  Copyright © 2019 Emanuela. All rights reserved.
//

import UIKit

class NewPageControl: UIPageControl {
    var indicator = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var progress: CGFloat = 0 {
        didSet {
            updateIndicator()
        }
    }
    
    override var currentPageIndicatorTintColor:UIColor? {
        get {
            return indicator.backgroundColor
        }
        set {
            indicator.backgroundColor = newValue
        }
    }
    
    override var pageIndicatorTintColor:UIColor? {
        set {
            super.pageIndicatorTintColor = newValue
            super.currentPageIndicatorTintColor = super.pageIndicatorTintColor
        }
        get {
            return super.pageIndicatorTintColor
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateCurrentPage()
        }
    }
    
    func updateIndicator() {
        guard progress != 0 else {
            return
        }
        
        let direction = Int(progress/abs(progress))
        let current = self.currentPage
        var next:Int = (self.currentPage + direction)%self.numberOfPages
        next = next < 0 ? numberOfPages-1 : next
        
        let distance = subviews[next].frame.origin - subviews[current].frame.origin
        
        let progressAbs = abs(progress)
        
        if next > current {
            if(progressAbs <= 0.5) {
                let newWidth = subviews[current].frame.size.width + distance.x * progressAbs * 2
                indicator.frame = CGRect(origin: subviews[current].frame.origin,
                                          size: CGSize(width: newWidth,
                                                       height: subviews[current].frame.size.height))
            }
            else {
                let newWidth = subviews[current].frame.size.width + distance.x * (2 - progressAbs * 2)
                let newX = subviews[current].frame.origin.x + distance.x * (progressAbs*2 - 1)
                indicator.frame = CGRect(x: newX,
                                          y: subviews[next].frame.origin.y,
                                          width: newWidth,
                                          height: subviews[next].frame.size.height)
            }
        }
        else {
            if(progressAbs <= 0.5) {
                let newWidth = subviews[current].frame.size.width + -distance.x * progressAbs * 2
                let newX = subviews[current].frame.origin.x + distance.x * (progressAbs*2)
                indicator.frame = CGRect(x: newX,
                                          y: subviews[current].frame.origin.y,
                                          width: newWidth,
                                          height: subviews[current].frame.size.height)
            }
            else {
                let newWidth = subviews[current].frame.size.width + -distance.x * (2 - progressAbs * 2)
                indicator.frame = CGRect(origin: subviews[next].frame.origin,
                                          size: CGSize(width: newWidth,
                                                       height: subviews[next].frame.size.height))
            }
        }
    }

    func updateCurrentPage() {
        if(currentPage >= 0 && currentPage < numberOfPages && indicator.frame.size != .zero){
            indicator.frame = subviews[currentPage].frame
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        indicator.backgroundColor = super.currentPageIndicatorTintColor
        super.currentPageIndicatorTintColor = super.pageIndicatorTintColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        indicator.backgroundColor = super.currentPageIndicatorTintColor
        super.currentPageIndicatorTintColor = super.pageIndicatorTintColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if indicator.frame.size.width == 0{
            guard let f = subviews.first else {
                return
            }
            indicator.frame = f.frame
            indicator.layer.cornerRadius = f.layer.cornerRadius
            self.addSubview(indicator)
        }
    }
}

public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
