//
//  LabelViewController.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/24.
//

import UIKit

class LabelViewController: UIViewController {
    
    var label: String!
    @IBOutlet weak var textField: UITextField!
    
    @objc func handleKeyboardDidShowNotificaion() {
        UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.textField.transform = CGAffineTransform(translationX: 0, y: -100)
        }.startAnimation()
    }
    
    @objc func handleKeyboardDidHideNotificaion() {
        UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.textField.transform = CGAffineTransform(translationX: 0, y: 100)
        }.startAnimation()  
    }
    
    func updateUI() {
        textField.text = label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        textField.becomeFirstResponder()
        textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShowNotificaion), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidHideNotificaion), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        label = textField.text
    }

}

extension LabelViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performSegue(withIdentifier: "unwindToEditAlarm", sender: nil)
    
        return true
    }
    
    
}
