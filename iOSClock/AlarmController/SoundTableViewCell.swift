//
//  SoundTableViewCell.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/25.
//

import UIKit

class SoundTableViewCell: UITableViewCell {
    
    @IBOutlet weak var soundLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
