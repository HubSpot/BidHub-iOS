//
//  ItemManager.swift
//  AuctionApp
//

import UIKit


class DataManager: NSObject {
 
    var allItems: [Item] = [Item]()

    var timer:NSTimer?
    
    var sharedInstance : DataManager {
        struct Static {
            static let instance : DataManager = DataManager()
        }
        
        return Static.instance
    }
    
    
    func getItems(completion: ([Item], NSError?) -> ()){
        let query = Item.query()
        query.limit = 1000
        query.addAscendingOrder("closetime")
        query.addAscendingOrder("name")
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error != nil{
                print("Error!! \(error)")
                completion([Item](), error)
            }else{
                if let itemsUW = results as? [Item] {
                    self.allItems = itemsUW
                    completion(itemsUW, nil)
                }
            }
        }
    }
    
    func searchForQuery(query: String) -> ([Item]) {
        return applyFilter(.Search(searchTerm: query))
    }
    
    func applyFilter(filter: FilterType) -> ([Item]) {
        return allItems.filter({ (item) -> Bool in
            return filter.predicate.evaluateWithObject(item)
        })
    }
    
    func bidOn(item:Item, amount: Int, completion: (Bool, errorCode: String) -> ()){
        
        let user = PFUser.currentUser()
        
        Bid(email: user.email, name: user.username, amount: amount, itemId: item.objectId)
        .saveInBackgroundWithBlock { (success, error) -> Void in
            
            if error != nil {
                
                if let errorString:String = error.userInfo["error"] as? String{
                    completion(false, errorCode: errorString)
                }else{
                    completion(false, errorCode: "")
                }
                return
            }
            
            let newItemQuery: PFQuery = Item.query()
            newItemQuery.whereKey("objectId", equalTo: item.objectId)
            newItemQuery.getFirstObjectInBackgroundWithBlock({ (item, error) -> Void in
                
                if let itemUW = item as? Item {
                    self.replaceItem(itemUW)
                }
                completion(true, errorCode: "")
            })
            
            let channel = "a\(item.objectId)"
            PFPush.subscribeToChannelInBackground(channel, block: { (success, error) -> Void in
                
            })
        }
    }
    
    func replaceItem(item: Item) {
        allItems = allItems.map { (oldItem) -> Item in
            if oldItem.objectId == item.objectId {
                return item
            }
            return oldItem
        }
    }
}


enum FilterType: CustomStringConvertible {
    case All
    case NoBids
    case MyItems
    case Search(searchTerm: String)
    
    var description: String {
        switch self{
        case .All:
            return "All"
        case .NoBids:
            return "NoBids"
        case .MyItems:
            return "My Items"
        case .Search:
            return "Searching"
        }
    }
    
    var predicate: NSPredicate {
        switch self {
        case .All:
            return NSPredicate(value: true)
        case .NoBids:
            return NSPredicate(block: { (object, bindings) -> Bool in
                if let item = object as? Item {
                    return item.numberOfBids == 0
                }
                return false
            })
        case .MyItems:
            return NSPredicate(block: { (object, bindings) -> Bool in
                if let item = object as? Item {
                    return item.hasBid
                }
                return false
            })

        case .Search(let searchTerm):
            return NSPredicate(format: "(donorName CONTAINS[c] %@) OR (name CONTAINS[c] %@) OR (itemDesctiption CONTAINS[c] %@)", searchTerm)
        default:
            return NSPredicate(value: true)
        }
    }
}