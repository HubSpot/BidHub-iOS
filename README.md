BidHub iOS
==============
iOS client for HubSpot's open-source silent auction app. For an overview of the auction app project, [check out our blog post about it](http://dev.hubspot.com/coming-soon)!

![](http://i.imgur.com/qYtj1hAl.jpg)

## Getting started
If you haven't yet, you're going to want to set up Parse by following the instructions in the [BidHub Cloud Code repository](https://github.com/HubSpot/BidHub-CloudCode). Make a note of your application ID and client key (Parse > Settings > Keys). All set?

We use CocoaPods for dependency management [(and a whole lot of other things)](http://dev.hubspot.com/blog/architecting-a-large-ios-app-with-cocoapods). If you don't have Cocoapods, install it first: `sudo gem install cocoapods`.

Then, `git clone` this repository. From the AuctionApp directory, run `pod install`, which will tell CocoaPods to grab all of the app's dependencies. Then, just open the `AuctionApp.xcworkspace` (not `AuctionApp.xcodeproj` - this will break CocoaPods) in Xcode. Edit *AuctionApp/AppDelegate.swift*, replacing `<your app id>` and `<your client key>` with the application ID and client key you copied from Parse. Run the app and you should be all set... almost!

## Push
