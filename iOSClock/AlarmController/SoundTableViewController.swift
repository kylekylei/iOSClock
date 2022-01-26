//
//  SoundTableViewController.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/25.
//

import UIKit

class SoundTableViewController: UITableViewController {
    
    var sound: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelection = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ringTones.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SoundTableViewCell.self)", for: indexPath) as! SoundTableViewCell        
        let row = indexPath.row
        
        cell.soundLabel.text = ringTones[row]
        
        if sound == ringTones[row]{
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        sound = ringTones[indexPath.row]
        tableView.reloadData()
    }    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
