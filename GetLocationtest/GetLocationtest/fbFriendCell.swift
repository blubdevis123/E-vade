//
//  fbFriendCell.swift
//  E-Vade
//
//  Created by Fhict on 21/10/15.
//  Copyright © 2015 Robin. All rights reserved.
//

import UIKit

class fbFriendCell: UITableViewCell {
    @IBOutlet weak var fbProfile: UIImageView!
    @IBOutlet weak var fbName: UILabel!
    @IBOutlet weak var fbEvadeSwitch: UISwitch!
    
    var fbFriend:Friend = Friend(id: "-1", name: "-1")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fbEvadeSwitch.setOn(false, animated: false)
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func evadeClicked(sender: AnyObject)
    {
        if(!fbEvadeSwitch.on)
        {
            fbEvadeSwitch.setOn(false, animated: true)
            self.fbFriend.UnEvade();
        }
        else if(fbEvadeSwitch.on)
        {
            fbEvadeSwitch.setOn(true, animated: true)
            self.fbFriend.Evade();
        }
    }
    
    func setFriend(fbFriend:Friend)
    {
        self.fbFriend = fbFriend
    }
    
}
