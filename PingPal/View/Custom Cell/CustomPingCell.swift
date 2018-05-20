//
//  CustomPingCell.swift
//  PingPal
//
//  Created by DJ on 4/11/18.
//  Copyright © 2018 DJ Rose. All rights reserved.
//

import UIKit

class CustomPingCell: UITableViewCell {

    @IBOutlet var dayOfWeekLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var senderLabel: UILabel!
    @IBOutlet var statusImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func chatPressed(_ sender: UIButton) {
    }
}
