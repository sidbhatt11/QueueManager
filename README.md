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
