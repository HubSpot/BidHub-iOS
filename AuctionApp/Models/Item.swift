//
//  Item.swift
//  AuctionApp
//
//  Created by Eoin on 17/11/2014.
//  Copyright (c) 2014 HubSpot. All rights reserved.
//

import UIKit

enum ItemWinnerType {
    case Single
    case Multiple
}

class Item: PFObject, PFSubclassing {
    
    @NSManaged var name:String
    @NSManaged var price:Int
    
    var currentPrice:[Int] {
        get {
            if let array = self["currentPrice"] as? [Int] {
                return array
            }else{
                return [Int]()
            }
        }
        set {
            self["currentPrice"] = newValue
        }
    }
    
    var currentWinners:[String] {
        get {
            if let array = self["currentWinners"] as? [String] {
                return array
            }else{
                return [String]()
            }
        }
        set {
            self["currentWinners"] = newValue
        }
    }
    
    var allBidders:[String] {
        get {
            if let array = self["allBidders"] as? [String] {
                return array
            }else{
                return [String]()
            }
        }
        set {
            self["allBidders"] = newValue
        }
    }
    
    var numberOfBids:Int {
        get {
            if let numberOfBidsUW = self["numberOfBids"] as? Int {
                return numberOfBidsUW
            }else{
                return 0
            }
        }
        set {
            self["numberOfBids"] = newValue
        }
    }

    
    var donorName:String {
        get {
            if let donor =  self["donorname"] as? String{
                return donor
            }else{
                return ""
            }
        }
        set {
            self["donorname"] = newValue
        }
    }
    var imageUrl:String {
        get {
            if let imageURLString = self["imageurl"] as? String {
                return imageURLString
            }else{
                return ""
            }
        }
        set {
            self["imageurl"] = newValue
        }
    }
    

    var itemDesctiption:String {
        get {
            if let desc = self["description"] as? String{
                return desc
            }else{
                return ""
            }
        }
        set {
            self["description"] = newValue
        }
    }
    
    var quantity: Int {
        get {
            if let quantityUW =  self["qty"] as? Int{
                return quantityUW
            }else{
                return 0
            }
        }
        set {
            self["qty"] = newValue
        }
    }
    
    var openTime: NSDate {
        get {
            if let open =  self["opentime"] as? NSDate{
                return open
            }else{
                return NSDate()
            }
        }
    }
    
    var closeTime: NSDate {
        get {
            if let close =  self["closetime"] as? NSDate{
                return close
            }else{
                return NSDate()
            }
        }
    }
    
    var winnerType: ItemWinnerType {
        get {
            if quantity > 1 {
                return .Multiple
            }else{
                return .Single
            }
        }
    }

    var minimumBid: Int {
        get {
            if !currentPrice.isEmpty {
                return minElement(currentPrice)
            }else{
                return price
            }
        }
    }
    
    var isWinning: Bool {
        get {
            let user = PFUser.currentUser()
            return contains(currentWinners, user.email)
        }
    }
    
    
    var hasBid: Bool {
        get {
            let user = PFUser.currentUser()
            return contains(allBidders, user.email)
        }
    }
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Item"
    }
}


