//
//  CharacterDetailViewController.swift
//  Marvelous
//
//  Created by Edouard Barbier on 30/04/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - @IBOUTLETS
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var segementedControl: UISegmentedControl!
    
    //MARK: - VARIABLES
    
    var characterManager: CharacterManager!
    var character: Character!
    var characterImage: UIImage!
    
    var tableViewContent = [String]() {
        
        didSet{
            
            tableView.reloadData()
            print(tableViewContent.count)
        }
    }
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = character.name
        
        if character.desc == "" {
            
            characterDescriptionLabel.text = "API uncomplete. There was no description for this character on Marvel. "
            
        } else {
        
            characterDescriptionLabel.text = character.desc
        }
        
        characterImageView.image = characterImage
        
        tableViewContent = characterManager.getCharacterItems(from: character, for: "comics")
        
        
        let dictArray = character.comics["items"] as! [[String:Any]]
        
        for dict in dictArray {
            
            for (key, value) in dict {
            
                if key == "name" {
                    tableViewContent.append(value as! String)
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - TABLEVIEW DELEGATE & DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = tableViewContent[indexPath.row]
        
        return cell
    }
    
    
    
    @IBAction func segmentedControlTapped(_ sender: Any) {

        tableViewContent = []
        
        switch segementedControl.selectedSegmentIndex {
        case 0:
            tableViewContent = characterManager.getCharacterItems(from: character, for: "comics")
        case 1:
            tableViewContent = characterManager.getCharacterItems(from: character, for: "series")
        case 2:
            tableViewContent = characterManager.getCharacterItems(from: character, for: "stories")
        default:
            break 
        }
        
        print("NUMBER OF ITEMS IN TABLEVIEW: \(tableViewContent.count)")
        
        tableView.reloadData()
    }
    

}
