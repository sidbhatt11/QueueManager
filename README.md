# QueueManager
Simple GCD wrapper to make your Swift code look beautiful.

Simple GCD code of performing a task asynchronously in a global queue and then performing another task on main queue upon its completion, usually looks like this :  		
```
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { () -> Void in
            // Download Image here
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Update UIImageView here
            })
        }  
```
  
Now by using QueueManager, you can make this look beautiful :  
```  
        QueueManager.globalQueueAsync(Block: { () -> Void in
            // Download Image
        }) { () -> Void in
            // Update UI
        }  
```

## How to use
### Getting Queues
Get main queue :  
```  
let mainQueue = QueueManager.mainQueue() // GCD: dispatch_get_main_queue()  
```
Get a global concurrent queue :  
```
let globalQueue = QueueManager.globalQueue() // GCD: dispatch_get_global_queue(0, 0)
```  
Get a custom concurrent queue :
```
let myConQueue = QueueManager.createNewConcurrentQueue(Name: “myConQueueName”, Priority: .High)
```
Get a custom serial queue :
```
let mySerialQueue = QueueManager.createNewSerialQueue(Name: “mySerialQueueName”, Priority: .Default)
```
Methods `createNewConcurrentQueue` and `createNewSerialQueue` take two arguments :  

1) Name:String - Non-Optional - Name of the Queue. Useful for Debugging.

2) Priority:QueuePriority - Optional - Options are : `.Default`, `.High`, `.Low` and `.Background`. Default value is `.Default`.

These QueuePriority options internally map to `qos_class_t` as following :
```
.Default - QOS_CLASS_DEFAULT
.High - QOS_CLASS_USER_INITIATED
.Low - QOS_CLASS_UTILITY
.Background - QOS_CLASS_BACKGROUND
```
Both methods `createNewConcurrentQueue` and `createNewSerialQueue` return a `dispatch_queue_t` ( just like `mainQueue()` and `globalQueue()` ), so if you want, you can pass them around in your GCD code as following : 
```
        dispatch_async(myConQueue) { () -> Void in
            // Some Task
        }
```
### Running Code Blocks in Queues
To run blocks on main queue, QueueManager has two `class func`(s) :
```
	/// Runs block on main queue asynchronously
    class func mainQueueAsync(Block blockToExecute:()->Void)
    
    /// Runs block on main queue synchronously
    class func mainQueueSync(Block blockToExecute:()->Void)
```
While using the functions above, your code will look like this :  
```
        QueueManager.mainQueueAsync { () -> Void in
            // Some Task on main queue
        }  
```
Now for running blocks on a global queue, QueueManager has four `class func`(s) :
```
	/// Runs block on global queue asynchronously
    class func globalQueueAsync(Block blockToExecute:()->Void)

    /// Runs block on global queue asynchronously with a CompletionBlock that runs on main queue asynchronously
    class func globalQueueAsync(Block blockToExecute:()->Void, CompletionBlock completionBlock:()->Void)
    
    /// Runs block on global queue synchronously
    class func globalQueueSync(Block blockToExecute:()->Void)
    
    /// Runs block on global queue synchronously with a CompletionBlock that runs on main queue asynchronously
    class func globalQueueSync(Block blockToExecute:()->Void, CompletionBlock completionBlock:()->Void)
```
And your code will look like this :  
```
        QueueManager.globalQueueAsync { () -> Void in
            // Some Task Here
        }

        QueueManager.globalQueueAsync(Block: { () -> Void in
            // Download Image
        }) { () -> Void in
            // Update UI
        }
```

Now for running code blocks on any `dispatch_queue_t` queue, There is an extension provided with QueueManager that makes use of QueueManager. It has following functions :
```
/// Runs block asynchronously
func async(Block blockToExecute:()->Void)

/// Runs block asynchronously with a CompletionBlock that runs on main queue asynchronously. DO NOT USE THIS ON MAIN QUEUE
func async(Block blockToExecute:()->Void, CompletionBlock completionBlock:()->Void)

/// Runs block synchronously
func sync(Block blockToExecute:()->Void)

/// Runs block synchronously with a CompletionBlock that runs on main queue asynchronously. DO NOT USE THIS ON MAIN QUEUE
func sync(Block blockToExecute:()->Void, CompletionBlock completionBlock:()->Void)
```
And while using them, your code will look like this :  
```
        myConQueue.async { () -> Void in
            // Some Task Here
        }

        myConQueue.async(Block: { () -> Void in
            // Download Image Here
        }) { () -> Void in
            // Update UI here
        }  
```
Since `QueueManager.mainQueue()` and `QueueManager.globalQueue()` also return a `dispatch_queue_t`, you can use these functions on them as well :  
```
        QueueManager.mainQueue().async { () -> Void in
            // Some Task Here
        }

        QueueManager.globalQueue().async { () -> Void in
            // Some Task Here
        }
```
Be careful with using these functions on main queue. Make sure you know what you are doing before you write that code.

## Important Note
While using functions with completion blocks, keep in mind that the block you pass to execute first, and the completion block, are two totally different blocks; Meaning you can’t access local variables created in first block in the completion block.

For example, the following is NOT possible as one would expect :
```
        QueueManager.globalQueueAsync(Block: { () -> Void in
            // Perform some task
            // Create some local variable
            let numberToPass:Int = 5
        }) { () -> Void in
            // Pass local variable to some function
            self.someFunction(Number: numberToPass)
        }
```
If you want to achieve the behaviour above, you can do something like this :  
```
        QueueManager.globalQueueAsync { () -> Void in
            
            // Perform some task
            // Create some local variable
            let numberToPass:Int = 5
            
            QueueManager.mainQueueAsync(Block: { () -> Void in
                // Pass local variable to some function
                self.someFunction(Number: numberToPass)
            })
        }
```
If you want to avoid nesting of these methods, you can follow this approach and design your code accordingly :  
```  
        QueueManager.globalQueueAsync(Block: { () -> Void in
            // Download and parse data
            // Update UITableView’s DataSource Array
        }) { () -> Void in
            // Reload UITablView
            self.tableView.reloadData()
        }
```

