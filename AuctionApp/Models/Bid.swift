//
//  Bid.swift
//  AuctionApp
//
//  Created by Eoin on 17/11/2014.
//  Copyright (c) 2014 HubSpot. All rights reserved.
//

import UIKit

class Bid: PFObject, PFSubclassing {
    
    @NSManaged var email: String
    @NSManaged var name: String
    
    var amount: Int {
        get {
            return self["amt"] as Int
        }
        set {
            self["amt"] = newValue
        }
    }
    
    var itemId: String {
        get {
            return self["item"] as String
        }
        set {
            self["item"] = newValue
        }
    }
    
    //Needed
    override init(){
        super.init()
    }
    
    init(email: String, name: String, amount: Int, itemId: String) {
        super.init()
        self.email = email
        self.name = name
        self.amount = amount
        self.itemId = itemId
    }
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "NewBid"
    }
}

enum BidType {
    case Extra(Int)
    case Custom(Int)
}