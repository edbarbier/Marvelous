//
//  CharactersViewController.swift
//  Marvelous
//
//  Created by Edouard Barbier on 28/04/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

class CharactersViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var characterManager: CharacterManager!
    
    override func viewDidLoad() {
        
        characterManager.getCharacters { (characterResult) -> Void in
            switch characterResult {
            case let .success(characters):
                print(characters.count)
            case let .failure(error):
                print("Error fetching Marvel Characters: \(error)")
            }
        }
    }
}
