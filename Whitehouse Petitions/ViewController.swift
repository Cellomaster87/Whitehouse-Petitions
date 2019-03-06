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
    

    // MARK: - Views managment
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* "https://api.whitehouse.gov/v1/petitions.json?limit=100" */
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        // try to convert that string into an URL
        if let url = URL(string: urlString) {
            // fetch that from the API
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    // MARK: - Methods
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
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

