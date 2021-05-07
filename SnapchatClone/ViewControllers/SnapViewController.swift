//
//  SnapViewController.swift
//  SnapchatClone
//
//  Created by Mert Kaan on 2.05.2021.
//

import UIKit
import ImageSlideshow

class SnapViewController: UIViewController {

    var selectedSnap : Snap?
    
    var InputArray = [KingfisherSource]()
    
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if let snap = selectedSnap {
            timeLabel.text = "Time Left : \(snap.timeDifferance)"
            
            for imageUrl in snap.imageUrlArray {
                InputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.90 ))
            imageSlideShow.backgroundColor = UIColor.white
            
            let pageIndicator = UIPageControl()
            
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            
            pageIndicator.pageIndicatorTintColor = UIColor.black
            
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            
            imageSlideShow.setImageInputs(InputArray)
            
            self.view.addSubview(imageSlideShow)
            
            self.view.bringSubviewToFront(timeLabel)
            
        }
     
    }
    

    
}
