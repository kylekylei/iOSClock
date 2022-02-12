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
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
