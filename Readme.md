# Transaction Suddenly /Unexpectedly/ Removed

## Intro
We experience a strange behaviour of SKPaymentQueue under iOS-9 and iOS-9.0.1. We suspect that this is an iOS issue. 
This example is a minimal app-frame that reproduces /demonstrates/ the problem.


## Facts
* Tested in sandbox environment.
* Tested in TestFlight environment.
* Never tested in production environment.
* Never tested for iOS-9.1 /beta/.

## App
This app requires one non-consumable IAP product with content hosted by Apple. 
App has only one button that starts the transaction/download process. 

## Issue
Downloading process is unexpectedly terminated when the app is moved from the foreground to the background and then back to the foreground.

To reproduce the issue ...

1. Adapt this project to your dev. environment (set NON_CONSUMABLE_PRODUCT_WITH_HOSTED_CONTENT to your product-id).

* Create a test app (iTunes Connect).

* Host a non-consumable IAP product (Application Loader).

2. Press the button "Get Product".

3. Wait until downloading starts.

4. Press Home button to resign the app.

5. (Re)Activate the app (touch the app icon).

6. SKPaymentQueue will eventually send one or two download events.
 
7. !! SKPaymentQueue will send the paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction])` message to the observer.

8. !! Downloading process is then terminated forever.


## Known Workarounds

* Keep the app in the foreground while downloading.

* Don't activate the app until the downloading process is completed (at the system level), then activate the app.
