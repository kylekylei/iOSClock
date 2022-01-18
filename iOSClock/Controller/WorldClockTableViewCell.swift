//
//  WorldClockTableViewCell.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/13.
//

import UIKit

var tableViewIsEditing = false



class WorldClockTableViewCell: UITableViewCell {
    @IBOutlet weak var relativeDateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var relativeHoursLabel: UILabel!    
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
