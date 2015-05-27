//
//  Bid.swift
//  AuctionApp
//

import UIKit

class Bid: PFObject, PFSubclassing {
    
    @NSManaged var email: String
    @NSManaged var name: String
    
    var amount: Int {
        get {
            return self["amt"] as! Int
        }
        set {
            self["amt"] = newValue
        }
    }
    
    var itemId: String {
        get {
            return self["item"] as! String
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
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String! {
        return "NewBid"
    }
}

enum BidType {
    case Extra(Int)
    case Custom(Int)
}