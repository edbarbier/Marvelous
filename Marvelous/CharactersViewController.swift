//
//  CharactersViewController.swift
//  Marvelous
//
//  Created by Edouard Barbier on 28/04/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit
import Foundation 

class CharactersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIScrollViewDelegate {
    
    
    //MARK: - @IBOUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - VARIABLES
    var characterManager: CharacterManager!

    static var imageCache = NSCache<AnyObject, AnyObject>()
    
    var charactersArray = [Character]()
    var filteredCharactersArray = [Character]()
    
    var inSearchMode = false

    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        let insets = UIEdgeInsetsMake(20.0, 0, 20.0, 0.0)
        collectionView.contentInset = insets
        
        characterManager.getCharacters { (characterResult) -> Void in
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - COLLECTION VIEW DELEGATE METHODS 
    //TODO: - Extract these methods and create a DataSource file for the CollectionView.
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return filteredCharactersArray.count
        }
        
        return charactersArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_CHARACTER, for: indexPath) as? CharacterCell {
            
            var character: Character!
            
            if inSearchMode {
                character = filteredCharactersArray[indexPath.row]
            } else {
                character = charactersArray[indexPath.row]
            }
            
            let imgUrl = characterManager.getCharacterImgUrl(from: character)
            
            //Checking if we can use an image in the cache
            if let cachedImg = CharactersViewController.imageCache.object(forKey: imgUrl as AnyObject) as? UIImage {
                
                cell.config(character: character, image: cachedImg)
                
                print("Image used from cache")
                
            } else {
              
                //Downloading image for character

                characterManager.fetchImage(for: character, completion: { (imageResult) in
                    switch imageResult {
                    case let .success(image):
                        cell.config(character: character, image: image)
                        print("Image saved in cache")
                        CharactersViewController.imageCache.setObject(image, forKey: imgUrl as AnyObject)
                        
                        DispatchQueue.main.async {
                            collectionView.reloadData()
                        }
                        
                        
                    case let .failure(error):
                        cell.config(character: character, image: nil)
                        print("Error downloading image: \(error)")
                    }
                })
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds
        
        let size = CGSize(width: screenSize.width/2 - 30, height: screenSize.width/2 - 30)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var charTapped: Character!
        
        if inSearchMode {
            
            charTapped = filteredCharactersArray[indexPath.row]
            
        } else {
            
            charTapped = charactersArray[indexPath.row]
        }
        
        performSegue(withIdentifier: SEGUE_DETAILS, sender: charTapped)
    }
    
    //MARK: - SCROLLVIEW DELEGATE METHODS
    
    //Dismissing keyboard when collectionView is scrolled
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView {
            
            view.endEditing(true)
        }
    }
    
    //MARK: - SEARCH BAR DELEGATE METHOD 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            view.endEditing(true)
            collectionView.reloadData()
        } else {
            
            inSearchMode = true
            let searchString = searchBar.text!.lowercased()
            print("SearchString: \(searchString)")
            filteredCharactersArray = charactersArray.filter({$0.name.lowercased().range(of: searchString) != nil })
            collectionView.reloadData()
        }
    }
    
    //MARK: - NAVIGATION 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SEGUE_DETAILS {
            
            if let vc = segue.destination as? CharacterDetailViewController {
                
                if let character = sender as? Character {
                    
                    vc.character = character
                    
                    let imgUrl = characterManager.getCharacterImgUrl(from: character)
                    let img = CharactersViewController.imageCache.object(forKey: imgUrl as AnyObject)
                    
                    vc.characterImage = img as! UIImage! 
                }
            }
        }
    }
}
