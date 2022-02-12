//
//  StopwatchTableViewCell.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/2/3.
//

import UIKit

class StopwatchTableViewCell: UITableViewCell {

    @IBOutlet weak var lapLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
