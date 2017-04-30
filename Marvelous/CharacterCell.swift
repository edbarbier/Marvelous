//
//  CharacterCell.swift
//  Marvelous
//
//  Created by Edouard Barbier on 29/04/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

class CharacterCell: UICollectionViewCell {
   
    //MARK: - @IBOUTLETS
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    
    //MARK: - VARIABLES
    var character: Character!
    
    //Config cell content
    func config(character: Character, image: UIImage?) {
        
        print("congif cell")
        
        self.character = character
        
        if let name = self.character.name as String? {
            characterNameLabel.text = name.uppercased()
        }
        
        if image != nil {
            characterImageView.image = image
        }
    }
    
    //Cleaning the cells before Reuse
    override func prepareForReuse() {
        characterImageView.image = nil
        characterNameLabel.text = ""
        
    }
    
    //Adding light borderRadius to the cells
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 3.0
    }
}
