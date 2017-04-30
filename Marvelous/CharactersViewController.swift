//
//  CharactersViewController.swift
//  Marvelous
//
//  Created by Edouard Barbier on 28/04/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

class CharactersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    
    //MARK: - @IBOUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - VARIABLES
    var characterManager: CharacterManager!

    var charactersArray = [Character]()
    var filteredCharacters = [Character]()
    var inSearchMode = false

    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let insets = UIEdgeInsetsMake(20.0, 0, 20.0, 0.0)
        collectionView.contentInset = insets
        
        characterManager.getCharactersFromJSONFile { (characterResult) -> Void in
            switch characterResult {
            case let .success(characters):
                
                self.charactersArray = characters
                
                for char in characters {
                    
                    print("Name: \(char.name), Description: \(char.desc)")
                }
                
                self.collectionView.reloadData()
                
                print("Number of characters received from Marvel API: \(characters.count)")
                
            case let .failure(error):
                print("Error fetching Marvel Characters: \(error)")
            }
        }
    }
    
    //MARK: - COLLECTION VIEW DELEGATE METHODS 
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("Nmber of items = \(charactersArray.count)")
        
        return charactersArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_CHARACTER, for: indexPath) as? CharacterCell {
            
            var character: Character!
            
            if inSearchMode {
                character = filteredCharacters[indexPath.row]
            } else {
                character = charactersArray[indexPath.row]
            }
            
            cell.config(character: character, image: nil)
            
            return cell
        } else {
            
            print("We are here")
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds
        
        let size = CGSize(width: screenSize.width/2 - 30, height: screenSize.width/2 - 30)
        
        return size
    }
    
}
