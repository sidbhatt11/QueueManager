//
//  HomeViewController.swift
//  queuemanagerdemo
//
//  Created by Siddharth Bhatt on 14/01/16.
//  Copyright © 2016 siddharthbhatt. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    private let queueManager = QueueManager()
    private var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    
    private func loadImage() {
        weak var wself = self
        
        let networkQueue = queueManager.createNewConcurrentQueue(Name: "NetworkQueue", Priority: .High)
        
        networkQueue.addBlock({
                // download the image here
                let imageURL = NSURL(string: "https://s-media-cache-ak0.pinimg.com/736x/1f/99/3b/1f993bf94d9856b966eb4b8c1dea03bf.jpg")!
            
                let imageData = NSData(contentsOfURL: imageURL)!
            
                wself!.image = UIImage(data: imageData)
            
                // never write code like this ^
                // this is just a quick dirty demo
            }) {
                // update the UI here
                if let imageToShow = wself?.image {
                    wself!.imageView.image = imageToShow
                }
        }
    }

}
