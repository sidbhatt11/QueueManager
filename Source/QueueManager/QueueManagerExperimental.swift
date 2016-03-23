//
//  QueueManagerExperimental.swift
//  queuemanagerdemo
//
//  Created by Siddharth Bhatt on 23/03/16.
//  Copyright © 2016 siddharthbhatt. All rights reserved.
//

import Foundation

enum QueuePriority {
    case Default
    case High
    case Low
    case Background
}

enum QueueType {
    case Concurrent
    case Serial
}

class QueueManager {
    
    // MARK: - Private Vars
    
    private static let minQueueRelativePriority:Int32 = -99 // Need to do something about this..
    
    // MARK: - Private Methods
    
    private class func getNewQueue(Type incomingQueueType:QueueType,Name name:String,Priority incomingPriority:QueuePriority?) -> dispatch_queue_t {
        
        var queuePriority:qos_class_t = QOS_CLASS_DEFAULT
        if let priority:QueuePriority = incomingPriority {
            switch priority {
            case .High:
                queuePriority = QOS_CLASS_USER_INITIATED
            case .Low:
                queuePriority = QOS_CLASS_UTILITY
            case .Background:
                queuePriority = QOS_CLASS_BACKGROUND
            case .Default:
                queuePriority = QOS_CLASS_DEFAULT // compiler made me do this..
            }
        }
        
        var queueType = DISPATCH_QUEUE_SERIAL // had to do this.. no choice..
        switch incomingQueueType {
        case .Serial:
            queueType = DISPATCH_QUEUE_SERIAL
        case .Concurrent:
            queueType = DISPATCH_QUEUE_CONCURRENT
        }
        
        let queueAttributes = dispatch_queue_attr_make_with_qos_class(queueType, queuePriority, self.minQueueRelativePriority)
        
        return dispatch_queue_create(name, queueAttributes)
    }
    
    // MARK: - Public Methods
    
    /**
     Returns a new Concurrent Queue with given name and QueuePriority
     - parameter name: Name of the Queue. Useful in Debugging
     - parameter priority: (Optional)Priority of the Queue. Default priority is 'Default'
     - returns: An Async Queue with type dispatch_queue_t
     */
    class func createNewConcurrentQueue(Name name:String,Priority incomingPriority:QueuePriority?) -> dispatch_queue_t {
        return getNewQueue(Type: .Concurrent, Name: name, Priority: incomingPriority)
    }
    
    /**
     Returns a new Serial Queue with given name and QueuePriority
     - parameter name: Name of the Queue. Useful in Debugging
     - parameter priority: (Optional)Priority of the Queue. Default priority is 'Default'
     - returns: A Sync Queue with type dispatch_queue_t
     */
    class func createNewSerialQueue(Name name:String,Priority incomingPriority:QueuePriority?) -> dispatch_queue_t {
        return getNewQueue(Type: .Serial, Name: name, Priority: incomingPriority)
    }
    
    
    // MARK: - Main Queue
    
    /// Returns main queue. Same as dispatch_get_main_queue()
    class func mainQueue() -> dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    
    /// Runs block on main queue asynchronously
    class func mainQueueAsync(Block blockToExecute:()->Void) {
        dispatch_async(mainQueue()) { () -> Void in
            blockToExecute()
        }
    }
    
    /// Runs block on main queue synchronously
    class func mainQueueSync(Block blockToExecute:()->Void) {
        dispatch_sync(mainQueue()) { () -> Void in
            blockToExecute()
        }
    }
    
    // MARK: - Global Queue
    
    /// Returns a global (concurrent by default) queue. Same as dispatch_get_global_queue(0, 0)
    class func globalQueue() -> dispatch_queue_t {
        return  dispatch_get_global_queue(0, 0)
    }
    
    /// Runs block on global queue asynchronously
    class func globalQueueAsync(Block blockToExecute:()->Void) {
        dispatch_async(globalQueue()) { () -> Void in
            blockToExecute()
        }
    }

    /// Runs block on global queue asynchronously with a CompletionBlock that runs on main queue asynchronously
    class func globalQueueAsync(Block blockToExecute:()->Void, CompletionBlock completionBlock:()->Void) {
        dispatch_async(globalQueue()) { () -> Void in
            blockToExecute()
            mainQueueAsync(Block: { () -> Void in
                completionBlock()
            })
        }
    }
    
    /// Runs block on global queue synchronously
    class func globalQueueSync(Block blockToExecute:()->Void) {
        dispatch_sync(globalQueue()) { () -> Void in
            blockToExecute()
        }
    }
    
    /// Runs block on global queue synchronously with a CompletionBlock that runs on main queue asynchronously
    class func globalQueueSync(Block blockToExecute:()->Void, CompletionBlock completionBlock:()->Void) {
        dispatch_sync(globalQueue()) { () -> Void in
            blockToExecute()
            mainQueueAsync(Block: { () -> Void in
                completionBlock()
            })
        }
    }
}