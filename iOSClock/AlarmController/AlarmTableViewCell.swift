//
//  AlarmTableViewCell.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/18.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var clockTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
