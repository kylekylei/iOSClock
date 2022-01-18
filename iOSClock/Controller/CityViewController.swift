//
//  CityViewController.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/13.
//

import UIKit

class CityViewController: UIViewController {
    
    var city: City?

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabbleView: UITableView!
    
    var cityDictionary = [String: [City]]()
    var citySectionTitles = [String]()
    let timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
    var cities = [City]()
    
    var searching = false
    var searchedCities = [City]()
         
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Build array of city struct
        for timeZoneIdentifier in timeZoneIdentifiers {
            let city = City(identifier: timeZoneIdentifier)
            cities.append(city)
        }
        
        // Build dictionary of timeZone city
        for city in cities {
            let cityKey = String(city.cityName.prefix(1))
            if var cityValues = cityDictionary[cityKey] {
                cityValues.append(city)
                cityDictionary[cityKey] = cityValues
            } else {
                cityDictionary[cityKey] = [city]
            }
        }
        
        citySectionTitles = [String](cityDictionary.keys)
        citySectionTitles = citySectionTitles.sorted(by: < )
        
        
        navigationItem.hidesBackButton = true
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true        
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if searching {
            guard let row = tabbleView.indexPathForSelectedRow?.row else { return }
            city = searchedCities[row]
        } else {
            guard let row = tabbleView.indexPathForSelectedRow?.row else { return }
                if let section = tabbleView.indexPathForSelectedRow?.section {
                    let cityValue = citySectionTitles[section]
                    let cityKeys = cityDictionary[cityValue]
                    city = cityKeys![row]
                }
        }
    }
}


extension CityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if searching {
            return 1
        } else {
            return citySectionTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedCities.count
            
        } else {
            let cityKey =  citySectionTitles[section]
            if let cityValues = cityDictionary[cityKey] {
                return cityValues.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CityTableViewCell.self)", for: indexPath) as! CityTableViewCell
                
        var city: City?
        
        if searching {
            city = searchedCities[indexPath.row]
        } else {
            let cityKey = citySectionTitles[indexPath.section]
            if let cityValue = cityDictionary[cityKey] {
                city = cityValue[indexPath.row]
            }
        }
        cell.cityLabel.text = city?.cityName
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searching ? nil : citySectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return searching ? nil : citySectionTitles
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCities = cities.filter { $0.cityName.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searching = true
        tabbleView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.searchTextField.text = ""
        self.dismiss(animated: true, completion: nil)
    }
}
