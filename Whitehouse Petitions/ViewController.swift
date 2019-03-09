//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Michele Galvagno on 06/03/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    // MARK: - Properties
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    // MARK: - Views managment
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetList))
            
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItems = [filterButton, resetButton]
        
        
        /* "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100" */
        let urlString: String
            
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        // try to convert that string into an URL
        if let url = URL(string: urlString) {
            // fetch that from the API
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                
                return
            }
            showError()
        }
    }
    
    // MARK: - Methods
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            
            tableView.reloadData()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Data source", message: "These petitions come from the \nWe The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Thank you!", style: .default, handler: nil))
        
        present(ac, animated: true)
    }
    
    @objc func filterPetitions() {
        let ac = UIAlertController(title: "Filter petitions", message: "Type in to filter...", preferredStyle: .alert)
        ac.addTextField()
        
        let filterAction = UIAlertAction(title: "Filter", style: .default) {
            [weak self, weak ac] _ in
            guard let filterWord = ac?.textFields?[0].text else { return }
            self?.showPetitions(for: filterWord)
            self?.tableView.reloadData()
        }
        
//        let resetAction = UIAlertAction(title: "Reset", style: .destructive, handler: resetList)
        
        ac.addAction(filterAction)
//        ac.addAction(resetAction)
        present(ac, animated: true)
    }
    
    func showPetitions(for filter: String) {
        filteredPetitions = petitions.filter { $0.title.contains(filter) }
        print(filteredPetitions)
    }
    
    @objc func resetList(action: UIAlertAction) {
        filteredPetitions = petitions
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
