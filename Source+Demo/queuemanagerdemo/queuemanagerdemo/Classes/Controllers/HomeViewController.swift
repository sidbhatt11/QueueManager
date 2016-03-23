//
//  HomeViewController.swift
//  queuemanagerdemo
//
//  Created by Siddharth Bhatt on 14/01/16.
//  Copyright © 2016 siddharthbhatt. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { () -> Void in
            // Download Image here
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Update UIImageView here
            })
        }
        
        QueueManager.mainQueueAsync { () -> Void in
            // Some Task on main queue
        }
        
        QueueManager.mainQueueSync { () -> Void in
            // Some Task on main queue
        }
        
        QueueManager.globalQueueAsync(Block: { () -> Void in
            // Download Image
        }) { () -> Void in
            // Update UI
        }
        
        QueueManager.globalQueueSync(Block: { () -> Void in
            // Some Task here
        }) { () -> Void in
            // Some Task on main queue here
        }
        
        let networkQueue = QueueManager.createNewConcurrentQueue(Name: "NetworkQueue", Priority: .High)
        let diskIOQueue = QueueManager.createNewSerialQueue(Name: "DiskIOQueue", Priority: .Default)
        
        networkQueue.async(Block: { () -> Void in
            // Download Image Here
        }) { () -> Void in
            // Update UI here
        }
        
        networkQueue.sync(Block: { () -> Void in
            // Some Task here
        }) { () -> Void in
            // Some Task on main thread here
        }
        
        diskIOQueue.async(Block: { () -> Void in
            // Write to disk here
        }) { () -> Void in
            // Show alert to user here
        }
        
        diskIOQueue.sync(Block: { () -> Void in
            // Some Task here
        }) { () -> Void in
            // Some Task on main thread here
        }
        
    }
    
}
