//
//  DigitViewController.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/28.
//

import UIKit

class DigitViewController: UIViewController {
    
    @IBOutlet weak var digitTimeLabel: UILabel! {
        didSet {
            digitTimeLabel.textAlignment = .center
        }
    }
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
   
    }

}
