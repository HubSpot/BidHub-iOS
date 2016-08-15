//
//  ItemTableViewCell.swift
//  AuctionApp
//

import UIKit

protocol ItemTableViewCellDelegate {
    
    func cellDidPressBid(item: Item)
    
}

class ItemTableViewCell: UITableViewCell {

    @IBOutlet var cardContainer: UIView!
    @IBOutlet var donorAvatar: UIImageView!
    @IBOutlet var bidNowButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var shadowView: UIView!
    @IBOutlet var moreInfoLabel: UILabel!
    @IBOutlet var moreInfoView: UIView!
    @IBOutlet var itemDescriptionLabel: UILabel!
    @IBOutlet var itemTitleLabel: UILabel!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var currentBidLabel: UILabel!
    @IBOutlet var numberOfBidsLabel: UILabel!
    @IBOutlet var itemDonorLabel: UILabel!
    @IBOutlet var headerBackground: UIView!
    @IBOutlet var availLabel: UILabel!
    var alreadyLoaded: Bool!
    
    let defaultBackgroundColor = UIColor(white: 0, alpha: 0.7)
    let winningBackgroundColor = UIColor(red: 126.0/255.0, green: 211.0/255.0, blue: 33.0/255.0, alpha: 0.8)
    let outbidBackgroundColor = UIColor(red: 243.0/255.0, green: 158.0/255.0, blue: 18.0/255.0, alpha: 0.8)
    
    let defaultColor = UIColor(white: 0, alpha: 1)
    let winningColor = UIColor(red: 126.0/255.0, green: 211.0/255.0, blue: 33.0/255.0, alpha: 1)
    let outbidColor = UIColor(red: 243.0/255.0, green: 158.0/255.0, blue: 18.0/255.0, alpha: 1)
    
    var delegate: ItemTableViewCellDelegate?
    var item: Item?
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImageView.contentMode = .ScaleAspectFill
        itemImageView.clipsToBounds = true
        alreadyLoaded = false
        
        shadowView.backgroundColor = UIColor(patternImage: UIImage(named:"cellBackShadow")!)
        
        donorAvatar.layer.cornerRadius = donorAvatar.frame.size.height/2
        donorAvatar.layer.masksToBounds = true

        cardContainer.layer.cornerRadius = 4
        cardContainer.clipsToBounds = true

    }

    func callDelegateWithBid(){
        if let delegateUW = delegate {
            if let itemUW = item {
                delegateUW.cellDidPressBid(itemUW)
            }
        }
    }
    
    func setWinning(){
        headerBackground.backgroundColor = winningBackgroundColor
        moreInfoView.hidden = false
        moreInfoView.backgroundColor = winningBackgroundColor
        if let itemUW = item {

            switch(itemUW.winnerType){
            case .Multiple:
                let user = PFUser.currentUser()
                if let index = itemUW.currentWinners.indexOf(user.email){
                    moreInfoLabel.text = "YOUR BID IS #\(index + 1)"
                }else{
                    fallthrough
                }
            case .Single:
                moreInfoLabel.text = "YOUR BID IS WINNING. NICE!"
            }
        }
    }
    
    func setOutbid(){
        headerBackground.backgroundColor = outbidBackgroundColor
        moreInfoView.hidden = false
        moreInfoView.backgroundColor = outbidBackgroundColor
        moreInfoLabel.text = "YOU'VE BEEN OUTBID. TRY HARDER?"
    }
    
    func setDefault(){
        headerBackground.backgroundColor = defaultBackgroundColor
        moreInfoView.hidden = true
        moreInfoView.backgroundColor = defaultBackgroundColor
    }
    
    
    @IBAction func bidNowPressed(sender: AnyObject) {
        callDelegateWithBid()
    }
    

}
