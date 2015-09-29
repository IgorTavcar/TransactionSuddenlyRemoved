import UIKit
import StoreKit


// Read Readme.md

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SKPaymentTransactionObserver {
    var window: UIWindow?
    
    
    // MARK: UIApplicationDelegate
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        return true
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
    }
    
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
    
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    
    func applicationWillTerminate(application: UIApplication) {
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }
    
    
    
    // MARK: SKPaymentTransactionObserver
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                NSLog("Transaction \(transaction.payment.productIdentifier) - purchased")
                if transaction.downloads.count > 0 {
                    NSLog("- start downloading")
                    SKPaymentQueue.defaultQueue().startDownloads(transaction.downloads)
                }
            case SKPaymentTransactionState.Restored:
                NSLog("Transaction \(transaction.payment.productIdentifier) - restored")
                if transaction.downloads.count > 0 {
                    NSLog("- start downloading")
                    SKPaymentQueue.defaultQueue().startDownloads(transaction.downloads)
                }
            case SKPaymentTransactionState.Purchasing:
                NSLog("Transaction \(transaction.payment.productIdentifier) - purchasing")
            case SKPaymentTransactionState.Deferred:
                NSLog("Transaction \(transaction.payment.productIdentifier) - deferred")
            case SKPaymentTransactionState.Failed:
                NSLog("Transaction \(transaction.payment.productIdentifier) - failed with \(transaction.error)")
            }
        }
    }
    
    
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.downloads.count > 0 {
                let download = transaction.downloads[0]
                
                switch download.downloadState {
                case SKDownloadState.Active:
                    NSLog("Transaction unexpectedly removed - \(transaction.payment.productIdentifier) - download active.")
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("StoreKitUpdate", object: nil,
                        userInfo:["info" : "transaction unexpectedly removed"])
                    
                case SKDownloadState.Paused:
                    NSLog("Transaction unexpectedly removed - \(transaction.payment.productIdentifier) - download paused.")
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("StoreKitUpdate", object: nil,
                        userInfo:["info" : "transaction unexpectedly removed"])
                    
                case SKDownloadState.Waiting:
                    NSLog("Transaction unexpectedly removed - \(transaction.payment.productIdentifier) - download waiting.")
                    NSNotificationCenter.defaultCenter().postNotificationName("StoreKitUpdate", object: nil,
                        userInfo:["info" : "transaction unexpectedly removed"])
                    
                default:
                    NSLog("Transaction removed.")
                }
            }
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        NSLog("Transaction failed with \(error)")
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        NSLog("Restore finished - queued \(queue.transactions)")
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        for download in downloads {
            switch download.downloadState {
            case SKDownloadState.Active:
                NSLog("Downloaded \(download.transaction.payment.productIdentifier) - \(download.progress)")
                NSNotificationCenter.defaultCenter().postNotificationName("StoreKitUpdate", object: nil,
                    userInfo:["info" : String(format: "content downloading - %.2f%%", download.progress * 100)])
                
            case SKDownloadState.Paused:
                NSLog("Downloaded \(download.transaction.payment.productIdentifier) - paused")
                NSNotificationCenter.defaultCenter().postNotificationName("StoreKitUpdate", object: nil,
                    userInfo:["info" : "download paused"])
                
            case SKDownloadState.Waiting:
                NSLog("Downloaded \(download.transaction.payment.productIdentifier) - waiting")
                
            case SKDownloadState.Cancelled:
                NSLog("Downloaded \(download.transaction.payment.productIdentifier) - canceled")
                NSNotificationCenter.defaultCenter().postNotificationName("StoreKitUpdate", object: nil,
                    userInfo:["info" : "download cancelled"])
                queue.finishTransaction(download.transaction)
                
            case SKDownloadState.Failed:
                NSLog("Downloaded \(download.transaction.payment.productIdentifier) - failed with \(download.error)")
                NSNotificationCenter.defaultCenter().postNotificationName("StoreKitUpdate", object: nil,
                    userInfo:["info" : "download failed"])
                queue.finishTransaction(download.transaction)
                
            case SKDownloadState.Finished:
                NSLog("Downloaded \(download.transaction.payment.productIdentifier) - finished")
                NSNotificationCenter.defaultCenter().postNotificationName("StoreKitUpdate", object: nil,
                    userInfo:["info" : "download successfully finished"])
                queue.finishTransaction(download.transaction)
            }
        }
    }
}
