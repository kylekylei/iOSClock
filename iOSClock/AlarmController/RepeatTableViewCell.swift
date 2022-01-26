//
//  RepeatTableViewCell.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/20.
//

import UIKit

class RepeatTableViewCell: UITableViewCell {

    @IBOutlet weak var weekDayButton: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
