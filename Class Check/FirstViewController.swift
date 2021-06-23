//
//  FirstViewController.swift
//  Class Check
//
//  Created by Leon Yee on 11/22/19.
//  Copyright © 2019 Company. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides:[slide] = [];
    var imageView: UIImageView!
    //var backgroundScrollView: UIScrollView!
    var background: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.background = UIView(frame: view.bounds)
        self.background.backgroundColor = UIColor(patternImage: UIImage(named: "firstviewbackground")!)
        self.view.addSubview(self.background)
        view.sendSubviewToBack(background)
        
        scrollView.delegate = self
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
    }
    
        
    func createSlides() -> [slide] {
        
        let slide1:slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! slide
        slide1.backgroundColor = UIColor(patternImage: UIImage(named: "firstviewbackground")!)
        slide1.image.image = UIImage(named: "classcheck")
        slide1.title.text = "Welcome to Class Check"
        slide1.descriptionLabel.text = "An easy way to keep track of all your extracurricular classes"
        
        let slide2:slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! slide
        slide2.backgroundColor = UIColor(patternImage: UIImage(named: "firstviewbackground")!)
        slide2.image.image = UIImage(named: "classcheck")
        slide2.title.text = "A Simple UI"
        slide2.descriptionLabel.text = "Simply create a Class with the number of classes in a bundle and the interval between classes"
        
        let slide3:slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! slide
        slide3.backgroundColor = UIColor(patternImage: UIImage(named: "firstviewbackground")!)
        slide3.image.image = UIImage(named: "classcheck")
        slide3.title.text = "A Simple UI"
        slide3.descriptionLabel.text = "In the Class, simply press the + button to signify that you have taken the class"
        
        slide3.nextButton.layer.borderWidth = 1.0
        slide3.nextButton.layer.borderColor = UIColor.white.cgColor
        slide3.nextButton.layer.cornerRadius = 8
        slide3.nextButton.setTitleColor(UIColor.white, for: .normal)
        slide3.nextButton.setTitle("→", for: .normal)
        slide3.nextButton.addTarget(self, action: #selector(goToApp), for: .touchUpInside)
        
        return [slide1, slide2, slide3]
    }
    
    @objc func goToApp(sender: UIButton!) {
        performSegue(withIdentifier: "toApp", sender: self)
        /*
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavController") as! UINavigationController
        self.navigationController?.pushViewController(newViewController, animated: true)
        */
    }
    
    func setupSlideScrollView(slides : [slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.5) {
            
            slides[0].image.transform = CGAffineTransform(scaleX: (0.5-percentOffset.x)/0.5, y: (0.5-percentOffset.x)/0.5)
            slides[1].image.transform = CGAffineTransform(scaleX: percentOffset.x/0.5, y: percentOffset.x/0.5)
            
        } else if(percentOffset.x > 0.5 && percentOffset.x <= 1) {
            slides[1].image.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.5, y: (1-percentOffset.x)/0.5)
            slides[2].image.transform = CGAffineTransform(scaleX: percentOffset.x/1, y: percentOffset.x/1)
            
        }

        
    }
    
}

