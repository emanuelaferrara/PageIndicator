//
//  PageViewController.swift
//  PageIndicator
//
//  Created by Emanuela Ferrara on 29/01/2019.
//  Copyright © 2019 Emanuela. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    var pageControl = AnimatedPageControl()
    var scrollLock: Bool = true
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        scrollLock = false
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        scrollLock = true
    }
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    

    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "sbBlue"),
                self.newVc(viewController: "sbRed"),
                self.newVc(viewController: "sbGreen")]
    }()

    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = AnimatedPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.5)
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.pageControl.currentPage = 0
        self.view.addSubview(pageControl)
        setupBottomControls()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        if completed {
            self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
        }
    }
    
    private func setupBottomControls(){
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}


extension PageViewController: UIScrollViewDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        
        self.delegate = self
        
        configurePageControl()
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollLock {
            let progress: CGFloat = (scrollView.contentOffset.x - view.frame.size.width)/view.frame.size.width
            self.pageControl.progress = progress
        }
    }
}
