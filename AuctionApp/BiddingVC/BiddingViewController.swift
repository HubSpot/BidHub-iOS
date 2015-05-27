//
//  BiddingViewController.swift
//  AuctionApp
//

import UIKit

protocol BiddingViewControllerDelegate {
    func biddingViewControllerDidBid(viewController: BiddingViewController, onItem: Item, amount: Int)
    func biddingViewControllerDidCancel(viewController: BiddingViewController)
}

private enum BiddingViewControllerState{
    case Custom
    case Standard
}

class BiddingViewController: UIViewController {

    @IBOutlet var darkView: UIView!
    @IBOutlet var popUpContainer: UIView!
    @IBOutlet var predifinedButtonsContainerView: UIView!
    @IBOutlet var customBidButton: UIButton!
    @IBOutlet var customBidTextField: UITextField!
    @IBOutlet var plusOneButton: UIButton!
    @IBOutlet var plusTenButton: UIButton!
    @IBOutlet var plusFiveButton: UIButton!
    var delegate: BiddingViewControllerDelegate?
    var item: Item?
    var startPrice = 0
    private var state :BiddingViewControllerState = .Standard
    
    var incrementOne = 0
    var incrementFive = 0
    var incrementTen = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customBidTextField.alpha = 0.0
        
        if let itemUW = item{
            
            incrementOne  = itemUW.priceIncrement
            incrementFive = 2*itemUW.priceIncrement
            incrementTen  = 5*itemUW.priceIncrement
            
            switch(itemUW.winnerType){
            case .Multiple:
                if itemUW.currentWinners.isEmpty{
                    setupForSingle(itemUW.price)
                }else{
                    setupForSingle(itemUW.currentPrice.last!)
                }
//                setupForMultiple()
            case .Single:
                if itemUW.currentWinners.isEmpty{
                    setupForSingle(itemUW.price)
                }else{
                    setupForSingle(itemUW.currentPrice.first!)
                }
            }
            
            popUpContainer.backgroundColor = UIColor.whiteColor()
            popUpContainer.layer.cornerRadius = 5.0
            
            customBidButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 18.0)!
            customBidButton.setTitleColor(UIColor(red: 33/225, green: 161/225, blue: 219/225, alpha: 1), forState: .Normal)
            
            customBidTextField.font = UIFont(name: "Avenir-Light", size: 24.0)
            customBidTextField.textColor = UIColor(red: 33/225, green: 161/225, blue: 219/225, alpha: 1)
            customBidTextField.textAlignment = .Center
            
            IHKeyboardAvoiding.setBuffer(20)
            IHKeyboardAvoiding.setPadding(20)
            IHKeyboardAvoiding.setAvoidingView(view, withTarget: popUpContainer)
            
            animateIn()
        }
    }

    @IBAction func didTapBackground(sender: AnyObject) {
        if delegate != nil {
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.popUpContainer.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
                self.darkView.alpha = 0
            }, completion: { (finished: Bool) -> Void in
                self.delegate!.biddingViewControllerDidCancel(self)
            })
            
        }
    }
    func setupForSingle(startAmount: Int) {
        
        startPrice = startAmount
        
        var bidAttrs = [NSFontAttributeName : UIFont(name: "Avenir-Light", size: 14.0)! , NSForegroundColorAttributeName: UIColor.grayColor()] as NSDictionary
        var otherAttrs = [NSFontAttributeName : UIFont(name: "Avenir-Light", size: 24.0)!, NSForegroundColorAttributeName: UIColor(red: 33/225, green: 161/225, blue: 219/225, alpha: 1)]
        
        plusOneButton.titleLabel?.textAlignment = .Center
        plusFiveButton.titleLabel?.textAlignment = .Center
        plusTenButton.titleLabel?.textAlignment = .Center

        let one = NSMutableAttributedString(string: "BID\n", attributes: bidAttrs as [NSObject : AnyObject])
        one.appendAttributedString(NSMutableAttributedString(string: "$\(startAmount + incrementOne)", attributes: otherAttrs))
        plusOneButton.setAttributedTitle(one, forState: .Normal)
        
        let five = NSMutableAttributedString(string: "BID\n", attributes: bidAttrs as [NSObject : AnyObject])
        five.appendAttributedString(NSMutableAttributedString(string: "$\(startAmount + incrementFive)", attributes: otherAttrs))
        plusFiveButton.setAttributedTitle(five, forState: .Normal)
        
        let ten = NSMutableAttributedString(string: "BID\n", attributes: bidAttrs as [NSObject : AnyObject])
        ten.appendAttributedString(NSMutableAttributedString(string: "$\(startAmount + incrementTen)", attributes: otherAttrs))
        plusTenButton.setAttributedTitle(ten, forState: .Normal)
        
   
    }
    
    func setupForMultiple() {
        self.customBidTextField.alpha = 1.0
        self.predifinedButtonsContainerView.alpha = 0.0
        self.customBidButton.setTitle("Bid", forState: .Normal)
        state = .Custom
    }

    func didSelectAmount(bidType: BidType) {
        
        var amount = 0
        switch bidType {
        case .Custom(let total):
            amount = total
        case .Extra(let aditional):
            amount = startPrice + aditional
        }
        
        if delegate != nil {
            if let itemUW = item {
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.popUpContainer.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
                    self.darkView.alpha = 0
                }, completion: { (finished: Bool) -> Void in
                    self.delegate!.biddingViewControllerDidBid(self, onItem: itemUW, amount: amount)
                })
                
                
            }
        }
    }
    
    @IBAction func customAmountPressed(sender: AnyObject) {
        
        switch state {
        case .Custom:
            if let amount = customBidTextField.text.toInt(){
                didSelectAmount(.Custom(amount))
            }else{
                didTapBackground("")
            }
        case .Standard:
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.setupForMultiple()
                self.customBidTextField.becomeFirstResponder()
            })
        }
    }

    @IBAction func bidOneDollarPressed(sender: AnyObject) {
        didSelectAmount(.Extra(incrementOne))
    }

    @IBAction func bidFiveDollarPressed(sender: AnyObject) {
        didSelectAmount(.Extra(incrementFive))
    }
    
    @IBAction func bidTenDollarPressed(sender: AnyObject) {
        didSelectAmount(.Extra(incrementTen))
    }
    
    func animateIn(){
        popUpContainer.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
        
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                self.popUpContainer.transform = CGAffineTransformIdentity
                self.darkView.alpha = 1.0
                
            },
            completion: { (fininshed: Bool) -> () in

            }
        )
    }


}
