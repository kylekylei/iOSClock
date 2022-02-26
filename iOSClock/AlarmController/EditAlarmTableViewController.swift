//
//  EditAlarmTableViewController.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/20.
//

import UIKit

class EditAlarmTableViewController: UITableViewController {
    
    var alarmClock = AlarmClock()
    var willDelete = false
    
    @IBOutlet weak var staticTableView: UITableView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var repeatDayLabel: UILabel!
    @IBOutlet weak var labelNameLabel: UILabel!
    @IBOutlet weak var soundNameLabel: UILabel!
    @IBOutlet weak var snoozeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.locale = Locale(identifier: "en_GB" )

        updateUI()
    }
    
    
    @IBAction func unwindToEditAlarm(_ unwindSegue: UIStoryboardSegue) {
        if let sourceController = unwindSegue.source as? RepeatTableViewController, let repeatDays = sourceController.repeatDays {
            alarmClock.repeatDays = repeatDays
        }
        if let sourceController = unwindSegue.source as? LabelViewController, let label = sourceController.label {
            alarmClock.label = label
        }
        
        if let sourceController = unwindSegue.source as? SoundTableViewController, let sound = sourceController.sound {
            alarmClock.sound = sound
        }
        updateUI()
    }
    
    func updateUI() {
        timePicker.date = alarmClock.time
        repeatDayLabel.text = alarmClock.repeatDayDescription
        labelNameLabel.text = alarmClock.label
        soundNameLabel.text = alarmClock.sound
        snoozeSwitch.isOn = alarmClock.snooze ? true : false
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func snoozeSwitch(_ sender: UISwitch) {
        alarmClock.snooze = alarmClock.snooze ? false : true
        snoozeSwitch.isOn = !snoozeSwitch.isOn ? false : true
        print("snooze: \( alarmClock.snooze)", "snoozeSwitch: \(snoozeSwitch.isOn)")
    }
    
    @IBAction func deleteCell(_ sender: UIButton) {
        willDelete = true
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? RepeatTableViewController {
            controller.repeatDays = alarmClock.repeatDays
        }
        if let controller = segue.destination as? LabelViewController {
            controller.label = alarmClock.label
        }
        if let controller = segue.destination as? SoundTableViewController {
            controller.sound = alarmClock.sound
        }
        
        alarmClock.time = timePicker.date
    } 

}
