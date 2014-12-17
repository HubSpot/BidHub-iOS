BidHub iOS
==============
iOS client for HubSpot's open-source silent auction app. For an overview of the auction app project, [check out our blog post about it](http://dev.hubspot.com/blog/building-an-auction-app-in-a-weekend)!

![](http://i.imgur.com/qYtj1hAl.jpg)

## Getting started
If you haven't yet, you're going to want to set up Parse by following the instructions in the [BidHub Cloud Code repository](https://github.com/HubSpot/BidHub-CloudCode). Make a note of your application ID and client key (Parse > Settings > Keys). All set?

We use CocoaPods for dependency management [(and a whole lot of other things)](http://dev.hubspot.com/blog/architecting-a-large-ios-app-with-cocoapods). If you don't have Cocoapods, install it first: `sudo gem install cocoapods`.

Then, `git clone` this repository. From the AuctionApp directory, run `pod install`, which will tell CocoaPods to grab all of the app's dependencies. Then, just open `AuctionApp.xcworkspace` (not `AuctionApp.xcodeproj` - this will break CocoaPods) in Xcode. 

Edit *AuctionApp/AppDelegate.swift*, replacing `<your app id>` and `<your client key>` with the application ID and client key you copied from Parse. Run the app and you should be all set... almost! Try bidding on something. To keep an eye on the action, check out the [Web Panel](https://github.com/HubSpot/BidHub-WebAdmin) where you can see all your items and bids.

Push isn't going to work yet, but you should be able to see Test Object 7 and bid on it. If you have the Android app up and running, and already bid on the Test Object, your Android phone will receive a sassy push notification.

## Customization

There's a few HubSpot-specific images that you can change to your liking:
* `loginBlurredBackground` is the login background
* `AppIcon` is the app icon (you see where this is going)

## Push
Setting up push for iOS devices takes a bit of work. It's an ordeal, but a manageable ordeal, and it's been [well documented by Parse](https://parse.com/tutorials/ios-push-notifications). Follow their guide up to Step 4 and you'll be fine. Steps 5 and beyond cover adding push to the app, which we've already done.
