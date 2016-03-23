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
Get main queue :  
```  
let mainQueue = QueueManager.mainQueue() // GCD: dispatch_get_main_queue()  
```
Get a global Concurrent queue :  
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






