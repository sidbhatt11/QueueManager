//
//  QueueManager.swift
//  commit
//
//  Created by Siddharth Bhatt on 10/01/16.
//  Copyright © 2016 leftshift. All rights reserved.
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
    private var allAsyncQueues:NSMutableArray
    private var allSyncQueues:NSMutableArray
    private var minQueueRelativePriority:Int32
    
    // MARK: - init
    init() {
        allAsyncQueues = NSMutableArray()
        allSyncQueues = NSMutableArray()
        minQueueRelativePriority = -99
    }
    
    // MARK: - Private Methods
    private func getNewQueue(Type incomingQueueType:QueueType,Name name:String,Priority incomingPriority:QueuePriority?) -> dispatch_queue_t {
        
        var pointerToArrayToAddQueueIn:AutoreleasingUnsafeMutablePointer<NSMutableArray> = nil
        func assignPointerTo(AddressToArray incomingArrayPointer:AutoreleasingUnsafeMutablePointer<NSMutableArray>) {
            pointerToArrayToAddQueueIn = incomingArrayPointer
        }
        
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
            assignPointerTo(AddressToArray: &allSyncQueues)
        case .Concurrent:
            queueType = DISPATCH_QUEUE_CONCURRENT
            assignPointerTo(AddressToArray: &allAsyncQueues)
        }
        
        let queueAttributes = dispatch_queue_attr_make_with_qos_class(queueType, queuePriority, minQueueRelativePriority)

        let queue = dispatch_queue_create(name, queueAttributes)
        
        let arrayToAddQueueIn:NSMutableArray = pointerToArrayToAddQueueIn.memory
        arrayToAddQueueIn.addObject(queue)
        
        return queue
    }
    
    // MARK: - Public Methods
    
    /**
        Returns an NSArray of all the Async Queues created
        - returns: an NSArray of all the Async Queues created
    */
    func getAllAsyncQueues() -> NSArray {
        return self.allAsyncQueues as NSArray
    }

    /**
        Returns an NSArray of all the Sync Queues created
        - returns: an NSArray of all the Sync Queues created
     */
    func getAllSyncQueues() -> NSArray {
        return self.allSyncQueues as NSArray
    }
    
    /**
        Returns a new Concurrent Queue with given name and QueuePriority
        - parameter name: Name of the Queue. Useful in Debugging
        - parameter priority: (Optional)Priority of the Queue. Default priority is 'Default'
        - returns: An Async Queue with type dispatch_queue_t
    */
    func createNewConcurrentQueue(Name name:String,Priority incomingPriority:QueuePriority?) -> dispatch_queue_t {
        return getNewQueue(Type: .Concurrent, Name: name, Priority: incomingPriority)
    }
    
    /**
        Returns a new Serial Queue with given name and QueuePriority
        - parameter name: Name of the Queue. Useful in Debugging
        - parameter priority: (Optional)Priority of the Queue. Default priority is 'Default'
        - returns: A Sync Queue with type dispatch_queue_t
     */
    func createNewSerialQueue(Name name:String,Priority incomingPriority:QueuePriority?) -> dispatch_queue_t {
        return getNewQueue(Type: .Serial, Name: name, Priority: incomingPriority)
    }
    
    
    // MARK: - Class Methods
    /**
        Returns Main Queue
        - returns: Main queue with type dispatch_queue_t
    */
    class func getMainQueue() -> dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    
    /**
        Returns A Global Queue (Concurrent by default)
        - returns: Main queue with type dispatch_queue_t
     */
    class func getGlobalQueue() -> dispatch_queue_t {
        return  dispatch_get_global_queue(0, 0)
    }
    
}

extension dispatch_queue_t {
    
    func addBlock(BlockToExecute:() -> Void){
        dispatch_async(self, BlockToExecute)
    }
    
    func addBlock(BlockToExecute:() -> Void, CompletionBlock:() -> Void){
        dispatch_async(self) {
            BlockToExecute()
            QueueManager.getMainQueue().addBlock({
                CompletionBlock()
            })
        }
    }
}