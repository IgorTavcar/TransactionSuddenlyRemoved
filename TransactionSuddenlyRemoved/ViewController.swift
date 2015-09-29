//
//  ViewController.swift
//  TransactionSuddenlyRemoved
//
//  Created by Igor Tavcar on 29/09/15.
//  Copyright (c) 2015 Resonanca IT d.o.o. All rights reserved.
//


import UIKit
import StoreKit


// Read Readme.md

class ViewController: UIViewController, SKProductsRequestDelegate {
    let NON_CONSUMABLE_PRODUCT_WITH_HOSTED_CONTENT = "bug.example.ios9.storekit.tsrcontent"
    
    var products : [SKProduct]?
    var invalidProductIdentifiers : [String]?
    
    var requestingProducts: Bool
    
    var currentInfo: String?
    
    var retrievedProduct: SKProduct? {
        if let retrieved = products {
            if retrieved.count == 1 {
                return retrieved[0]
            }
        }
        return nil
    }
    
    @IBOutlet weak var getButton: UIButton!
    
    
    required init?(coder aDecoder: NSCoder) {
        requestingProducts = false
        super.init(coder: aDecoder)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "StoreKitUpdateNotif:", name: "StoreKitUpdate", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        requestProductsIfNeeded()
        
        updateUi()
    }
    
    @IBAction func getAction(sender: AnyObject) {
        if let product = retrievedProduct {
            if SKPaymentQueue.canMakePayments() {
                let payment = SKPayment(product:product)
                SKPaymentQueue.defaultQueue().addPayment(payment)
            } else {
                NSLog("Can't make payments")
            }
        } else {
            NSLog("Products not retrieved")
        }
    }
    
    
    // MARK: Private
    
    private func requestProductsIfNeeded() {
        if requestingProducts || retrievedProduct != nil {
            return;
        }
        
        requestingProducts = true
        
        let IDs : Set<String> = [NON_CONSUMABLE_PRODUCT_WITH_HOSTED_CONTENT]
        let productsRequest = SKProductsRequest(productIdentifiers:IDs)
        
        productsRequest.delegate = self;
        
        NSLog("Requesting product with identifier \(IDs)")
        
        productsRequest.start();
    }
    
    private func updateUi() {
        if let product = retrievedProduct {
            if let info = currentInfo {
                getButton.setTitle("\(info)", forState: UIControlState.Normal)
                return
            }
            
            getButton.setTitle("Get \(product.localizedTitle)", forState: UIControlState.Normal)
            return
        }
        
        getButton.setTitle("SKProduct not retrieved", forState: UIControlState.Normal)
    }
    
    
    // MARK: Notifications
    
    func StoreKitUpdateNotif(notif: NSNotification) {
        if let info = notif.userInfo {
            currentInfo = info["info"] as? String
        } else {
            currentInfo = nil
        }
        
        updateUi()
    }
    
    
    // MARK: SKProductsRequestDelegate
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        products = response.products;
        invalidProductIdentifiers = response.invalidProductIdentifiers;
        
        NSLog("Retrieved \(products?.count) products and  \(invalidProductIdentifiers?.count) invalid identifiers.")
        
        requestingProducts = false;
        
        updateUi()
    }
}
