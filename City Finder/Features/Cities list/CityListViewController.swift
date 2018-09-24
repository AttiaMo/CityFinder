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
    fileprivate var citiesStringsArray = [String]()
    fileprivate var sortedCities = [City]()
    
    fileprivate lazy var filteredCities = [String]()
    fileprivate lazy var seperator = "=="
    
    fileprivate var citiesTrie = Trie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortedCities = loadJson(filename: "cities")
        bindData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Inserts words into a trie.  If the trie is non-empty, don't do anything.
    private func bindData() {
        for index in 0...sortedCities.count-1{
            let city = sortedCities[index]
            let text = String(format: "\(city.name ?? ""),\(city.country ?? "")\(self.seperator)\(index)")
            citiesStringsArray.append(text)
            citiesTrie.insert(word: text)
        }
        filteredCities = citiesStringsArray
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
            self.filteredCities = self.citiesStringsArray
            self.reloadTable()
        }else{
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else {
                    return
                }
                //Filter data in search in tries in background to avoid lagging in UI
                self.filteredCities = self.citiesTrie.findWordsWithPrefix(prefix: searchText)
                
                DispatchQueue.main.async { [weak self] in
                    //Bind new filtered data to table in main queue
                    self?.reloadTable()
                }
            }
        }
    }
    
    private func reloadTable(){
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
// MARK: - TableView

extension CityListViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCities.count > 0 ? self.filteredCities.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = filteredCities[indexPath.row].components(separatedBy: seperator)[0]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let city = sortedCities[Int(filteredCities[indexPath.row].components(separatedBy: seperator)[1]) ?? 0]
        vc.city = city
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
