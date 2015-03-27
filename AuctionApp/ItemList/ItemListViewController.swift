//
//  ItemListViewController.swift
//  AuctionApp
//

import UIKit

extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
}

class ItemListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,ItemTableViewCellDelegate, BiddingViewControllerDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var items:[Item] = [Item]()
    var timer:NSTimer?
    var filterType: FilterType = .All
    var sizingCell: ItemTableViewCell?
    var bottomContraint:NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SVProgressHUD.setForegroundColor(UIColor(red: 157/225, green: 19/225, blue: 43/225, alpha: 1.0))
        SVProgressHUD.setRingThickness(2.0)
        
        
        let colorView:UIView = UIView(frame: CGRectMake(0, -1000, view.frame.size.width, 1000))
        colorView.backgroundColor = UIColor.whiteColor()
        tableView.addSubview(colorView)

        //Refresh Control
        let refreshView = UIView(frame: CGRect(x: 0, y: 10, width: 0, height: 0))
        tableView.insertSubview(refreshView, aboveSubview: colorView)

        refreshControl.tintColor = UIColor(red: 157/225, green: 19/225, blue: 43/225, alpha: 1.0)
        refreshControl.addTarget(self, action: "reloadItems", forControlEvents: .ValueChanged)
        refreshView.addSubview(refreshControl)
        
        
        sizingCell = tableView.dequeueReusableCellWithIdentifier("ItemTableViewCell") as? ItemTableViewCell

        if iOS8 {
            tableView.estimatedRowHeight = 392
            tableView.rowHeight = UITableViewAutomaticDimension
        }
        self.tableView.alpha = 0.0
        reloadData(silent: false, initialLoad: true)

        let user = PFUser.currentUser()
        println("Logged in as: \(user.email)")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushRecieved:", name: "pushRecieved", object: nil)
        timer = NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: "reloadItems", userInfo: nil, repeats: true)
        timer?.tolerance = 10.0
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        timer?.invalidate()
    }
    
    
    func pushRecieved(notification: NSNotification){
        
        if let aps = notification.object?["aps"] as? [NSObject: AnyObject]{
            if let alert = aps["alert"] as? String {
                CSNotificationView.showInViewController(self, tintColor: UIColor.whiteColor(), font: UIFont(name: "Avenir-Light", size: 14)!, textAlignment: .Center, image: nil, message: alert, duration: 5.0)
                
            }
        }
        reloadData()
        
        
    }
    
    //Hack for selectors and default parameters
    func reloadItems(){
        reloadData()
    }
    
    func reloadData(silent: Bool = true, initialLoad: Bool = false) {
        if initialLoad {
            SVProgressHUD.show()
        }
        DataManager().sharedInstance.getItems{ (items, error) in
        
            if error != nil {
                //Error Case
                if !silent {
                    self.showError("Error getting Items")
                }
                println("Error getting items")
                
            }else{
                self.items = items
                self.filterTable(self.filterType)
            }
            self.refreshControl.endRefreshing()
            
            if initialLoad {
                SVProgressHUD.dismiss()
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.tableView.alpha = 1.0
                })
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if iOS8 {
            return UITableViewAutomaticDimension
        }else{

            if let cell = sizingCell {
                
                let padding = 353
                let minHeightText: NSString = "\n\n"
                let font = UIFont(name: "Avenir Light", size: 15.0)!
                let attributes =  [NSFontAttributeName: font] as NSDictionary
                let item = items[indexPath.row]
                
                let minSize = minHeightText.boundingRectWithSize(CGSize(width: (view.frame.size.width - 40), height: 1000), options: .UsesLineFragmentOrigin, attributes: attributes, context: nil).height
                
                let maxSize = item.itemDesctiption.boundingRectWithSize(CGSize(width: (view.frame.size.width - 40), height: 1000), options: .UsesLineFragmentOrigin, attributes: attributes, context: nil).height + 50
                
                return (max(minSize, maxSize) + CGFloat(padding))

            }else{
                return 392
            }
            
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemTableViewCell", forIndexPath: indexPath) as ItemTableViewCell
        
        return configureCellForIndexPath(cell, indexPath: indexPath)
    }
    
    func configureCellForIndexPath(cell: ItemTableViewCell, indexPath: NSIndexPath) -> ItemTableViewCell {
        let item = items[indexPath.row]
        
        cell.itemImageView.image = nil
        var url:NSURL = NSURL(string: item.imageUrl)!
        cell.itemImageView.setImageWithURL(url)
        

        let fullNameArr = item.donorName.componentsSeparatedByString(" ")
        cell.donorAvatar.image = nil;
        if fullNameArr.count > 1{
            var firstName: String = fullNameArr[0]
            var lastName: String = fullNameArr[1]
            var inital: String = firstName[0]
            var donorAvatarStringUrl = "https://api.hubapi.com/socialintel/v1/avatars?email=\(inital)\(lastName)@hubspot.com"

            var donorAvatarUrl:NSURL = NSURL(string: donorAvatarStringUrl)!
            
            cell.donorAvatar.setImageWithURLRequest(NSURLRequest(URL: donorAvatarUrl), placeholderImage: nil, success: { (urlRequest: NSURLRequest!, response: NSURLResponse!, image: UIImage!) -> Void in
                cell.donorAvatar.image = image.resizedImageToSize(cell.donorAvatar.bounds.size)
                
            }, failure: { (urlRequest: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
                println("error occured: \(error)")
            })
        }
        
        cell.itemDonorLabel.text = item.donorName
        cell.itemTitleLabel.text = item.name
        cell.itemDescriptionLabel.text = item.itemDesctiption
        
        if item.quantity > 1 {
            var bidsString = ", ".join(item.currentPrice.map({bidPrice in "$\(bidPrice)"}))
            if countElements(bidsString) == 0 {
                bidsString = "(none yet)"
            }
            
            cell.itemDescriptionLabel.text =
                "\(item.quantity) available! Highest \(item.quantity) bidders win. Current highest bids are \(bidsString)" +
                "\n\n" + cell.itemDescriptionLabel.text!
        }
        cell.delegate = self;
        cell.item = item
        
        var price: Int?
        var lowPrice: Int?

        switch (item.winnerType) {
        case .Single:
            price = item.currentPrice.first
            cell.availLabel.text = "1 Available"
        case .Multiple:
            price = item.currentPrice.first
            lowPrice = item.currentPrice.last
            cell.availLabel.text = "\(item.quantity) Available"
        }
        
        let bidString = (item.numberOfBids == 1) ? "Bid":"Bids"
        cell.numberOfBidsLabel.text = "\(item.numberOfBids) \(bidString)"
        
        if let topBid = price {
            if let lowBid = lowPrice{
                if item.numberOfBids > 1{
                    cell.currentBidLabel.text = "$\(lowBid)-\(topBid)"
                }else{
                    cell.currentBidLabel.text = "$\(topBid)"
                }
            }else{
                cell.currentBidLabel.text = "$\(topBid)"
            }
        }else{
            cell.currentBidLabel.text = "$\(item.price)"
        }
        
        if !item.currentWinners.isEmpty && item.hasBid{
            if item.isWinning{
                cell.setWinning()
            }else{
                cell.setOutbid()
            }
        }else{
            cell.setDefault()
        }
        
        if(item.closeTime.timeIntervalSinceNow < 0.0){
            cell.dateLabel.text = "Sorry, bidding has closed"
            cell.bidNowButton.hidden = true
        }else{
            if(item.openTime.timeIntervalSinceNow < 0.0){
                //open
                cell.dateLabel.text = "Bidding closes \(item.closeTime.relativeTime().lowercaseString)."
                cell.bidNowButton.hidden = false
            }else{
                cell.dateLabel.text = "Bidding opens \(item.openTime.relativeTime().lowercaseString)."
                cell.bidNowButton.hidden = true
            }
        }
        
        return cell
    }
    
    //Cell Delegate
    func cellDidPressBid(item: Item) {
        
        
        let bidVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("BiddingViewController") as? BiddingViewController
        if let biddingVC = bidVC {
            biddingVC.delegate = self
            biddingVC.item = item
            addChildViewController(biddingVC)
            view.addSubview(biddingVC.view)
            biddingVC.didMoveToParentViewController(self)
        }
    }
        
    @IBAction func logoutPressed(sender: AnyObject) {
        PFUser.logOut()
        performSegueWithIdentifier("logoutSegue", sender: nil)
    }
    
    @IBAction func segmentBarValueChanged(sender: AnyObject) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        let segment = sender as UISegmentedControl
        switch(segment.selectedSegmentIndex) {
        case 0:
          filterTable(.All)
        case 1:
            filterTable(.NoBids)
        case 2:
            filterTable(.MyItems)
        default:
            filterTable(.All)
        }
    }
    
    func filterTable(filter: FilterType) {
        filterType = filter
        self.items = DataManager().sharedInstance.applyFilter(filter)
        self.tableView.reloadData()
    }
    
    func bidOnItem(item: Item, amount: Int) {
        
        SVProgressHUD.show()
        
        DataManager().sharedInstance.bidOn(item, amount: amount) { (success, errorString) -> () in
            if success {
                println("Wohooo")
                self.items = DataManager().sharedInstance.allItems
                self.reloadData()
                SVProgressHUD.dismiss()
            }else{
                self.showError(errorString)
                self.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    
    func showError(errorString: String) {
        
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            
            
            //make and use a UIAlertController
            let alertView = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)

            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                println("Ok Pressed")
            })
            
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        else {
            
            //make and use a UIAlertView
            
            let alertView = UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok")
            alertView.show()
        }
    }
    
    
    
    ///Search Bar
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filterTable(.All)
        }else{
            filterTable(.Search(searchTerm:searchText))
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.segmentBarValueChanged(segmentControl)
        searchBar.resignFirstResponder()
    }
    
    ///Bidding VC
    
    func biddingViewControllerDidBid(viewController: BiddingViewController, onItem: Item, amount: Int){
        viewController.view.removeFromSuperview()
        bidOnItem(onItem, amount: amount)
    }
    
    func biddingViewControllerDidCancel(viewController: BiddingViewController){
        viewController.view.removeFromSuperview()
    }
}

