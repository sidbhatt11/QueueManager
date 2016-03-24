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
        
        
        QueueManager.mainQueue().async { () -> Void in
            // Some Task Here
        }
        
        QueueManager.globalQueue().async { () -> Void in
            // Some Task Here
        }
        
        QueueManager.mainQueueAsync { () -> Void in
            // Some Task on main queue
        }
        
        QueueManager.mainQueueSync { () -> Void in
            // Some Task on main queue
        }
        
        QueueManager.globalQueueAsync { () -> Void in
            // Some Task Here
        }
        
        QueueManager.globalQueueSync { () -> Void in
            // Some Task Here
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
        
        networkQueue.async { () -> Void in
            // Some Task Here
        }
        
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
