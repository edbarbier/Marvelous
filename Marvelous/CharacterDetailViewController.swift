//
//  CharacterDetailViewController.swift
//  Marvelous
//
//  Created by Edouard Barbier on 30/04/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    //MARK: - @IBOUTLETS
    
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var segementedControl: UISegmentedControl!
    
    //MARK: - VARIABLES
    
    var character: Character!
    var characterImage: UIImage! 
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = character.name
        characterDescriptionLabel.text = character.desc
        characterImageView.image = characterImage
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    

}
