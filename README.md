# QueueManager
Simple GCD wrapper to make your Swift code look beautiful.

## Usage
Simple GCD code of performing a task asynchronously in a global queue and performing another task on main queue upon completion :  
  
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


