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
        slide1.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        slide1.backgroundColor = UIColor(patternImage: UIImage(named: "firstviewbackground")!)
        slide1.image.image = UIImage(named: "classcheck")
        slide1.title.text = "Welcome to Class Check"
        slide1.descriptionLabel.text = "An easy way to keep track of all your extracurricular classes"
        
        let slide2:slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! slide
        slide2.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        slide2.backgroundColor = UIColor(patternImage: UIImage(named: "firstviewbackground")!)
        slide2.image.image = UIImage(named: "example1")
        slide2.title.text = "Class Creation"
        slide2.descriptionLabel.text = "Simply create a Class with the number of classes in a bundle/package and the interval between classes. For example, 10 weekly math sessions would be '10' in the bundle, and 'Weekly' in the wheel picker."
        
        let slide3:slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! slide
        slide3.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        slide3.backgroundColor = UIColor(patternImage: UIImage(named: "firstviewbackground")!)
        slide3.image.image = UIImage(named: "example2")
        slide3.title.text = "Adding Classes"
        slide3.descriptionLabel.text = "In the Class, press the + button to signify that you have taken the class, and you can see past and future classes. Delete the rows to change the next class date, or press the + button anytime to change the next class date."
        
        let slide4:slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! slide
        slide4.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        slide4.backgroundColor = UIColor(patternImage: UIImage(named: "firstviewbackground")!)
        slide4.image.image = UIImage(named: "example3")
        slide4.title.text = "Viewing Classes"
        slide4.descriptionLabel.text = "Press the calendar button to view your classes in a calendar. The highlighted dates are your previous classes. For convenience, the class table is also listed."
        
        let slide5:slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! slide
        slide5.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        slide5.backgroundColor = UIColor(patternImage: UIImage(named: "firstviewbackground")!)
        slide5.image.image = UIImage(named: "classcheck")
        slide5.title.text = "ClassCheck+"
        slide5.descriptionLabel.text = "Thank you for using ClassCheck+!"
        
        slide5.nextButton.layer.borderWidth = 1.0
        slide5.nextButton.layer.borderColor = UIColor.white.cgColor
        slide5.nextButton.layer.cornerRadius = 8
        slide5.nextButton.setTitleColor(UIColor.white, for: .normal)
        slide5.nextButton.setTitle("→", for: .normal)
        slide5.nextButton.addTarget(self, action: #selector(goToApp), for: .touchUpInside)
        
        return [slide1, slide2, slide3, slide4, slide5]
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
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width * CGFloat(slides.count), height: UIScreen.main.bounds.size.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: UIScreen.main.bounds.size.width * CGFloat(i), y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
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
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            slides[0].image.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            slides[1].image.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.5) {
            slides[1].image.transform = CGAffineTransform(scaleX: (0.5-percentOffset.x)/0.25, y: (0.5-percentOffset.x)/0.25)
            slides[2].image.transform = CGAffineTransform(scaleX: percentOffset.x/0.5, y: percentOffset.x/0.5)
            
        } else if(percentOffset.x > 0.5 && percentOffset.x <= 0.75) {
            slides[2].image.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].image.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
            
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            slides[3].image.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            slides[4].image.transform = CGAffineTransform(scaleX: percentOffset.x/1, y: percentOffset.x/1)
            
        }

        
    }
    
}

