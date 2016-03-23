//
//  DispatchQueueExtension.swift
//  queuemanagerdemo
//
//  Created by Siddharth Bhatt on 23/03/16.
//  Copyright © 2016 siddharthbhatt. All rights reserved.
//

import Foundation

extension dispatch_queue_t {
    
    // MARK: - Async
    
    /// Runs block asynchronously
    func async(Block blockToExecute:()->Void) {
        dispatch_async(self) { () -> Void in
            blockToExecute()
        }
    }
    
    /// Runs block asynchronously with a CompletionBlock that runs on main queue asynchronously. DO NOT USE THIS ON MAIN QUEUE
    func async(Block blockToExecute:()->Void, CompletionBlock completionBlock:()->Void) {
        dispatch_async(self) { () -> Void in
            blockToExecute()
            QueueManagerExperimental.mainQueueAsync(Block: { () -> Void in
                completionBlock()
            })
        }
    }
    
    // MARK: - Sync
    
    /// Runs block synchronously
    func sync(Block blockToExecute:()->Void) {
        dispatch_sync(self) { () -> Void in
            blockToExecute()
        }
    }
    
    /// Runs block synchronously with a CompletionBlock that runs on main queue asynchronously. DO NOT USE THIS ON MAIN QUEUE
    func sync(Block blockToExecute:()->Void, CompletionBlock completionBlock:()->Void) {
        dispatch_sync(self) { () -> Void in
            blockToExecute()
            QueueManagerExperimental.mainQueueAsync(Block: { () -> Void in
                completionBlock()
            })
        }
    }
}