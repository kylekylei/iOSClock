//
//  WorldClockViewController.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/13.
//

import UIKit

class WorldClockViewController: UIViewController {
    var cities = [City]() {
        didSet {
            AppDelegate.editButtonSetting(cities, editButton)
            City.saveCities(cities)
        }
    }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    

    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cities = City.loadCities() {
            self.cities = cities
        }
               
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        AppDelegate.editButtonSetting(cities, editButton)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.tableView.isEditing ? nil : self.tableView.reloadData()
        }
        timer.fire()
        
    }
    
    @IBAction func editList(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Edit"
        tableView.reloadData()
    
    }
        
     @IBAction func unwindToWorldView(_ unwindSegue: UIStoryboardSegue) {
         if let sourceViewController = unwindSegue.source as? CityViewController,
            let city = sourceViewController.city {
             
             cities.insert(city, at: cities.count)
             let indexPath = IndexPath(row: cities.count-1, section: 0)
             tableView.insertRows(at: [indexPath], with: .automatic)
         }
    }
}



extension WorldClockViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(WorldClockTableViewCell.self)", for: indexPath) as! WorldClockTableViewCell
        
        let city = cities[indexPath.row]
        cell.cityLabel.text = city.cityName
        cell.relativeDateLabel.text = city.relativeDate
        cell.relativeHoursLabel.text = city.relativeHours
        if tableView.isEditing {
            cell.timeLabel.isHidden = true
        } else {
            cell.timeLabel.text = city.localTime
            cell.timeLabel.isHidden = false
        }
        return cell
    }
    
    //Editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        switch editingStyle {
        case .delete:
            cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert: return
        case .none:
            tableView.allowsSelectionDuringEditing = true
        default: return
        }
   
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        UITableViewCell.EditingStyle.delete
    }
    

    //Movable
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let city = cities[sourceIndexPath.row]
        cities.remove(at: sourceIndexPath.row)
        cities.insert(city, at: destinationIndexPath.row)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
