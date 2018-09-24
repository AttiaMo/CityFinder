//
//  CityListViewController.swift
//  City Finder
//
//  Created by Attia Mo on 9/24/18.
//  Copyright © 2018 Attia Mo. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var searchBar:UISearchBar!
    lazy var filteredCities = [City]()
    lazy var seperator = "=="
    var sortedCities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchData(){
        sortedCities = loadJson(filename: "cities")
        filteredCities = sortedCities
        self.tableView.reloadData()
    }
    
    private func loadJson(filename fileName: String) -> [City]{
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Array<City>.self, from: data).sorted(by: {$0.name! < $1.name!})
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return []
    }
}
extension CityListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.filterContentForSearchText(searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = ""
        searchBar.showsCancelButton = false
        self.filterContentForSearchText(searchBar.text ?? "")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        if searchText == "" {
            filteredCities = sortedCities
        }else{
            filteredCities = (sortedCities.filter({( city : City) -> Bool in
                return city.name?.lowercased().contains(searchText.lowercased()) ?? false
            }))
        }
        self.tableView.reloadData()
    }
}
// MARK: - TableView

extension CityListViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCities.count > 0 ? self.filteredCities.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = "\(filteredCities[indexPath.row].name ?? ""),\(filteredCities[indexPath.row].country ?? "")"
        return cell
    }
}
