//
//  RepeatTableViewController.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/20.
//

import UIKit

class RepeatTableViewController: UITableViewController {
    var repeatDays: [RepeatDay]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = true
   
    }
   


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repeatDays?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(RepeatTableViewCell.self)", for: indexPath) as! RepeatTableViewCell
        let row = indexPath.row
        cell.weekDayButton.text = "Every \(String(describing: repeatDays[row].weekDay))"
        if repeatDays[row].isRepeat {
            cell.accessoryType = .checkmark
            cell.selectionStyle = .none
        }

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            repeatDays[indexPath.row].isRepeat = false
            
        } else {
            cell?.accessoryType = .checkmark
            repeatDays[indexPath.row].isRepeat = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            repeatDays[indexPath.row].isRepeat = false
            
        } else {
            cell?.accessoryType = .checkmark
            repeatDays[indexPath.row].isRepeat = true
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
