//
//  NewPageControl.swift
//  PageIndicator
//
//  Created by Emanuela Ferrara on 29/01/2019.
//  Copyright © 2019 Emanuela. All rights reserved.
//

import UIKit

class NewPageControl: UIPageControl {
    var nuovo = UIView()
    var first = true;
    var defaultSize = CGSize.zero
    var animationDuration = 0.4
    override var currentPage: Int {
        didSet {
            if(currentPage != oldValue) {
                updateDot()
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func updateDot() {
        if nuovo.frame.origin.x < subviews[currentPage].frame.origin.x {
            rightAnimation()
        } else {
            leftAnimation()
        }
    }
    
    func leftAnimation() {
        let pos = subviews[currentPage].frame.origin
        let differenza =  pos - nuovo.frame.origin
        
        UIView.animate(withDuration: animationDuration/2, delay: 0, options: .curveEaseOut, animations: {
            self.nuovo.frame.size.width += abs(differenza.x)
            self.nuovo.frame.size.height += abs(differenza.y)
            self.nuovo.frame.origin = pos
        }) { (result) in
            UIView.animate(withDuration: self.animationDuration/2, animations: {
                [unowned self] in
                self.nuovo.frame.size = self.defaultSize
            })
        }
    }
    
    func rightAnimation() {
        let pos = subviews[currentPage].frame.origin
        let differenza =  pos - nuovo.frame.origin

        UIView.animate(withDuration: animationDuration/2, delay: 0, options: .curveEaseOut, animations: {
            self.nuovo.frame.size.width += differenza.x
            self.nuovo.frame.size.height += differenza.y
        }) { (result) in
            UIView.animate(withDuration: self.animationDuration/2, animations: {
                [unowned self] in
                self.nuovo.frame.origin = pos
                self.nuovo.frame.size = self.defaultSize
            })
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let f = subviews.first else {
            return
        }
        
        if first {
            defaultSize = f.frame.size
            nuovo.frame.origin = f.frame.origin
            first = false
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let f = subviews.first else {
            return
        }
        
        self.currentPageIndicatorTintColor = self.pageIndicatorTintColor
        
        nuovo = UIView(frame: f.frame);
        nuovo.backgroundColor = .white
        nuovo.layer.cornerRadius = f.layer.cornerRadius
        self.addSubview(nuovo)
    }
}


public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
