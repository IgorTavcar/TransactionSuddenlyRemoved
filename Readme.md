# Transaction Suddenly /Unexpectedly/ Removed from SKPaymentQueue

## Update
The SKPaymentQueue problem suddenly dissapeared. This project can be used as a minimalistic example of non-consumable IAP with content hosted on Apple.

## Intro
We experience a strange behaviour of SKPaymentQueue under iOS-9 and iOS-9.0.1. We suspect that this is an iOS issue. 
This example is a minimal app-frame that demonstrates the SKPaymentQueue related issue.

###
Issue reported to apple with id 22912989. 

###
Check out also our stackoverflow [question](http://stackoverflow.com/questions/32852495/ios9-skpaymentqueue-related-issue-transaction-unexpectedly-terminated-when-app).


## Facts
* Issue appears in sandbox environment (iOS 9.0.1).
* Issue appears in TestFlight environment (iOS 9.0.1).
* Never tested in production environemt.
* Never tested on iOS 9.1 /beta/.
* Issue never appears on iOS 8.4.1.

## App
This app requires one non-consumable IAP product with content hosted on Apple. 
App has only one button that starts the transaction/download process. 

## Issue
Download process is unexpectedly terminated when app is moved from the foreground to the background and then back to the foreground.

To reproduce the issue ...

1. Adapt this project to your dev. environment (set NON_CONSUMABLE_PRODUCT_WITH_HOSTED_CONTENT to your IAP product-id).

* Create a test app (iTunes Connect).

* Host a non-consumable IAP product (Application Loader).

2. Press the button "Get Product".

3. Wait until downloading starts.

4. Press Home button to resign the app.

5. (Re)Activate the app (touch the app icon).

6. SKPaymentQueue generates one or two additional download updates (in state active).
 
7. Unexpectedly: Method paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction])` is inovked. Downloading transaction has been removed from the queue.

8. !! No more events, downloading is terminated.


## Known Workarounds

* Keep the app in the foreground while downloading.

* Don't activate the app until the downloading is completed (at the system level), then activate the app.
