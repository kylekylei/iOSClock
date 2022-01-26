//
//  AlarmViewController.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/18.
//

import UIKit
import UserNotifications

class AlarmViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var alarmClocks = [AlarmClock]() {
        didSet {
            AlarmClock.saveAlarmClocks(alarmClocks)
            AppDelegate.editButtonSetting(alarmClocks, editButton)
        }
    }
    
    var alarmIndex :Int = 0

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        
        AppDelegate.editButtonSetting(alarmClocks, editButton)
        
        if let alarmClocks = AlarmClock.loadAlarmClocks() {
            self.alarmClocks = alarmClocks
        }
        
        tableView.allowsSelectionDuringEditing = true
        
        //Local notification
          
        UNUserNotificationCenter.current().delegate = self
    }
    
    func createNotifiction(time: Date, label: String, sound: String, weekdaySet: [Int]) {
        
        let content = UNMutableNotificationContent()
        content.title = "K Clock"
        content.body = label
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sound).mp3"))
        
        for weekday in weekdaySet {
            var dataComponets = Calendar.current.dateComponents([.hour, .minute], from: time)
            dataComponets.weekday = weekday

            let trigger = UNCalendarNotificationTrigger(dateMatching: dataComponets, repeats: false)
            let request = UNNotificationRequest(identifier: "set\(alarmIndex)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            alarmIndex += 1
        }
    }
    
    func removeNotification(at alarmIndex: Int) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["set\(alarmIndex)"])
    }
   
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner, .list, .badge])
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    
    
    @IBAction func editList(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Edit"
        tableView.reloadData()
    }
    

    
    @IBAction func enableSwitchChange(_ sender: UISwitch) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            alarmClocks[indexPath.row].isOn = sender.isOn
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindToAlarmView(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? EditAlarmTableViewController {
            let alarmClock = sourceViewController.alarmClock
            
            if let indexPath = tableView.indexPathForSelectedRow {
                if sourceViewController.willDelete == true {
                    alarmClocks.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .right)
                } else {
                    alarmClocks[indexPath.row] = alarmClock
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
            } else {
                alarmClocks.insert(alarmClock, at: 0)
                let indexPath = IndexPath(row: 0, section: 1)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        tableView.isEditing = false
        editButton.title =  "Edit"    
        tableView.reloadData()
    }

}



extension AlarmViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return alarmClocks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BedTimeTableViewCell.self)", for: indexPath) as? BedTimeTableViewCell else { return UITableViewCell() }
            
            cell.backgroundColor = .clear
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AlarmTableViewCell.self)", for: indexPath) as? AlarmTableViewCell else { return UITableViewCell() }
            let alarmClock = alarmClocks[indexPath.row]
            
            cell.clockTimeLabel.text = alarmClock.timeStr
            cell.clockTimeLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: alarmClock.isOn == true ? 1 : 0.68 )
            cell.descriptionLabel.text = alarmClock.description
            cell.descriptionLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: alarmClock.isOn == true ? 1 : 0.68)
            if tableView.isEditing {
                cell.enableSwitch.isHidden = true
            } else  {
                cell.enableSwitch.isHidden = false
                cell.enableSwitch.isOn = alarmClock.isOn ? true : false
            }
            if alarmClock.isOn == true {
                self.createNotifiction(time: alarmClock.time, label: alarmClock.label , sound: alarmClock.sound, weekdaySet: alarmClock.weekdaySet)
            }            
            
            cell.editingAccessoryType = .disclosureIndicator
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 24))
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: 300, height: 32))
        let font = UIFont.systemFont(ofSize: 24, weight: .bold)

        label.numberOfLines = 0
        label.textAlignment = .left
        
        if section == 0 {
            let bedAttacment = NSTextAttachment()
            bedAttacment.image = UIImage(systemName: "bed.double.fill")?.withTintColor(.white)
            bedAttacment.bounds = CGRect(x: 0, y: -2, width: 32, height: 20)
            let title = NSMutableAttributedString()
            
            let attributes = [NSAttributedString.Key.font: font]
            title.append(NSAttributedString(attachment: bedAttacment))
            title.append(NSAttributedString(string: " Sleep | Wake Up", attributes: attributes))
            label.attributedText = title
        }
        if section == 1 {
            label.text = String("Other")
            label.font = font
        }
        
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
        
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.section == 1 ? true : false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            alarmClocks.remove(at: indexPath.row)
            removeNotification(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert : return
        case .none: return
        default: return
        }
    }    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditAlarmTableViewController,
            let row = tableView.indexPathForSelectedRow?.row {
            if let section = tableView.indexPathForSelectedRow?.section, section == 1{               
                controller.alarmClock = alarmClocks[row]
                
                
            }
            
        }
    }
    
}


