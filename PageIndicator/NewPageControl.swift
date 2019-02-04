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
    var progress: CGFloat = 0 {
        didSet {
            //print(progress)
            updateAnimation()
        }
    }
    
    override var currentPage: Int {
        didSet {
            if(currentPage != oldValue) {
                updateDot()
                //print("ciao")
            }
        }
    }
    
    func updateAnimation() {
        guard progress != 0 else {
            return
        }
        let startPoint = subviews[currentPage].frame.origin
        let segno = Int(progress/abs(progress))
        let pro = abs(progress)
        var endIndex = (currentPage + segno)%self.numberOfPages
        if(endIndex < 0) {
            endIndex = numberOfPages - 1
        }
        let endPoint = subviews[endIndex].frame.origin
        
        let distanceToCover = endPoint - startPoint
        
        if endIndex < currentPage {
            if(pro <= 0.5) {
                nuovo.frame.size.width =  subviews[currentPage].frame.size.width + -distanceToCover.x * pro * 2
                nuovo.frame.origin.x = subviews[currentPage].frame.origin.x + distanceToCover.x * (pro*2)
            }
            else {
                nuovo.frame.size.width = subviews[currentPage].frame.size.width + -distanceToCover.x * (2 - pro * 2)
            }
        }
        else {
            if(pro <= 0.5) {
                nuovo.frame.size.width =  subviews[currentPage].frame.size.width + distanceToCover.x * pro * 2
            }
            else {
                nuovo.frame.size.width = subviews[currentPage].frame.size.width + distanceToCover.x * (2 - pro * 2)
                nuovo.frame.origin.x = subviews[currentPage].frame.origin.x + distanceToCover.x * (pro*2 - 1)
            }
        }
    }
    
    func updateDot() {
        if nuovo.frame.origin.x < subviews[currentPage].frame.origin.x {
            rightAnimation()
        } else {
            leftAnimation()
        }
    }
    
    func leftAnimation() {
        print("Left\n")
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
                print(nuovo.frame.origin)
    }
    
    func rightAnimation() {
        print("Right\n")
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
                print(nuovo.frame.origin)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let f = subviews.first else {
            return
        }
        
        if first {
            defaultSize = f.frame.size
            nuovo.frame.origin = f.frame.origin
            print("Pallino: ", nuovo.frame)
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
        
        self.addTarget(self, action: #selector(move), for: .touchDragInside)
    }
    
    @objc func move() {
        //print("MOVE")
    }
}


public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
