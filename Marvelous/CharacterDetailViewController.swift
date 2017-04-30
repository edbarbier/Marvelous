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
    
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    //MARK: - VARIABLES
    
    var character: Character!
    var characterImage: UIImage! 
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        characterNameLabel.text = character.name
        characterImageView.image = characterImage
        
    }

}
